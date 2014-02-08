ResearchIde::Application.routes.draw do
  devise_for :users
  root 'style_test#index'

  resources :projects
end
