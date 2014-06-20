Rails.application.routes.draw do
  authenticated :user, lambda {|u| u.admin?} do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
  resources :payments, except: [:edit, :destroy] do
    get :paypal_success, on: :member
    get :paypal_cancel, on: :member
  end

  devise_for :users
  root 'payments#new'
end
