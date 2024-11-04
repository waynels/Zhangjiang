require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin_users/sessions'
  }
  namespace :admin do
    mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
