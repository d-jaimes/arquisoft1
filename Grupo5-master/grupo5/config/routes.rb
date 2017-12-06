Rails.application.routes.draw do
  root 'api/registro_mediciones#index'

  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/home/login" => "home#login"
  get "/home/logout" => "home#logout"
  get "/home/error" => "home#error"

  namespace :api do
    resources :registro_mediciones, only: [:create, :index, :show, :destroy]
    resources :microcontrolador, only: [:index]
    resources :variable_ambiental, only: [:index, :create]
    resources :alert, only: [:index]
    resources :usuario, only: [:index]
    resources :actuador, only: [:index]

    get 'registro_mediciones/reporte/area' => "registro_mediciones#index_area", as: "registro_mediciones_area"
    get 'registro_mediciones/reporte/nivel' => "registro_mediciones#index_nivel", as: "registro_mediciones_nivel"
    get 'registro_mediciones/reporte/area/:area' => "registro_mediciones#index_area_more", as: "registro_mediciones_area_more"
    get 'registro_mediciones/reporte/nivel/:nivel' => "registro_mediciones#index_nivel_more", as: "registro_mediciones_nivel_more"
    get 'registro_mediciones/reporte/variable' => "registro_mediciones#index_variable", as: "registro_mediciones_variable"
    get 'registro_mediciones/reporte/variable/:variable' => "registro_mediciones#index_variable_more", as: "registro_mediciones_variable_more"
    get 'alert/area/:area/' => "alert#alerts_area", as: "alerts_area"
    get 'actuador/area/:area' => "actuador#actuadores_area", as: "actuadores_area"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
