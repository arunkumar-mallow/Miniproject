Rails.application.routes.draw do

  resources :products
  resources :denominations
  resources :bills do
    collection do
      post :get_price
      post :manual_denominations
    end
  end
  root "bills#index"
end
