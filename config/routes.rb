Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "creditors#index"

  resources :creditors, only: :index do
    get :pay, action: :edit
    put "add_drink/:type", action: :add_drink, as: :add_drink
    put "remove_drink/:type", action: :remove_drink, as: :remove_drink
  end

  put "data_configuration", action: :update, controller: :data_configurations
end
