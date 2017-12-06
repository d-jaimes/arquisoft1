Rails.application.routes.draw do
  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/home/login" => "home#login"
  get "/home/logout" => "home#logout"
  get "/home/error" => "home#error"

  namespace :api, defaults: {format: 'json'} do
    resources :registro_mediciones, only: [:create, :index, :show, :destroy]
    resources :microcontrolador, only: [:index]
    resources :variable_ambiental, only: [:index, :create]
    resources :alert, only: [:index]
    resources :usuario, only: [:index]
    resources :actuador, only: [:index]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
