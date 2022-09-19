// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('jquery')

$(document).on('turbolinks:load', function () {

    $(".fields").on("click", "#billing_section_form_delete_btn", function () {
        $(this).closest('fieldset').remove()
    });

    $('#new_bill').on('click', '.add_fields', function (event) {
        let regexp, time;
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $('.fields').append($(this).data('fields').replace(regexp, time));
        return event.preventDefault()
    })
})
