Rails.application.routes.draw do
  root controller: :visitors, action: :index
  devise_for :users

  namespace :cabinet do
    root controller: :dashboard, action: :dashboard
    resources :users
  end
end
