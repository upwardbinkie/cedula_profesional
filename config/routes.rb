# frozen_string_literal: true

Rails.application.routes.draw do
  resources :cedulas

  # StaticPages
  get "home" => "static_pages#home"
  get "about" => "static_pages#about"
  get "faq" => "static_pages#faq"
  get "terms" => "static_pages#terms"
  get "privacy" => "static_pages#privacy"

  # You can have the root of your site routed with "root"
  root "static_pages#home"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
