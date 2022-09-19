module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) { |builder| render(association.to_s, form: builder) }
    link_to(name, '#', class: "add_fields " + args[:class], data: { id: id, fields: fields.gsub("\n", "") })
  end

  def denominations_calculator(price)
    denominations = []
    Denomination.order("amount DESC").each { |d| denominations << d.amount.to_i }

    hash = {}
    denominations.each { |num| hash[num] = 0 }

    val, count = 0, 0

    while price > 0
      if denominations[val].to_i <= price
        hash[denominations[val]] = count += 1
        price -= denominations[val].to_i
      else
        count = 0
        val += 1
      end
    end

    hash
  end

  def remaining01(add)
    add.each do |amount, amount_count|
      count += 1
      sub_count = remaining[amount]
      puts "subcount: #{sub_count}, #{amount_count}"

      if sub_count <= amount_count
        add[amount] -= sub_count
      else
        required_amount = amount * sub_count
        puts "==================================="
        puts "in else required amount #{required_amount}"

        while required_amount > 0
          puts "in while required amount #{required_amount}, count: #{count}"
          break if count >= stop
          new_count = count

          while add[arr[new_count]] > 0
            if add[arr[new_count]] == 0
              new_count += 1
              break if new_count == stop

            else
              required_amount -= arr[new_count]
              puts "+++++++++++++++++++++++"
              puts "ra #{required_amount} -= #{arr[new_count]}"
              add[arr[new_count]] -= 1
              puts "add arr newcount #{add[arr[new_count]]}"
              break if required_amount == 0
            end
          end

          count += 1
          break if count == stop
        end
      end
    end
    add["remaining_amount"] = required_amount
    add
  end

  def denominations_return(product_price1, customer_given1, actual_bd, customer_manual = "0")

    if customer_manual == "0"
      customer_given = denominations_calculator(customer_given1)
    else
      customer_given = customer_manual
    end

    remaining = denominations_calculator(customer_given1 - product_price1)

    amo = []
    Denomination.order("amount DESC").each { |d| amo << d.amount.to_i }

    add = {}
    amo.each { |amount| add[amount.to_i] = actual_bd[amount.to_i].to_i + customer_given[amount.to_i].to_i }

    required_amount = 0

    count = -1
    arr = []
    add.each { |amount, _| arr << amount }
    stop = arr.size

    add.each do |amount, amount_count|
      count += 1
      sub_count = remaining[amount]

      if sub_count <= amount_count
        add[amount] -= sub_count
      else
        required_amount = amount * sub_count

        while required_amount > 0
          break if count >= stop
          new_count = count

          while add[arr[new_count]] > 0
            if add[arr[new_count]] == 0
              new_count += 1
              break if new_count == stop

            else
              required_amount -= arr[new_count]
              add[arr[new_count]] -= 1

              break if required_amount == 0
            end
          end

          count += 1
          break if count == stop
        end
      end
    end
    add["remaining_amount"] = required_amount
    add
  end

  def denominations_price(denominations)
    price = 0
    denominations.each { |key, value| price += key.to_i * value.to_i }
    price
  end

  def domination_diff(d1, d2)
    new = {}
    d1.each { |key, value| new[key] = (value.to_i - d2[key].to_i) > 0 ? "+#{value.to_i - d2[key].to_i}" : value.to_i - d2[key].to_i }
    new
  end

  def denominations_string_to_hash(string)
    return "0" if string == "0"
    manual_denominations_hash = {}
    string.split(",").each do |text|
      text = text.split(":")
      manual_denominations_hash[text[0].to_i] = text[1].to_i
    end
    manual_denominations_hash
  end

end
