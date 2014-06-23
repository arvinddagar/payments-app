Rails.application.routes.draw do
  match '/payments/payment', to: 'payments#payment', as: 'paymentspayment', via: [:get]
  match '/payments/relay_response', to: 'payments#relay_response', as: 'payments_relay_response', via: [:post]
  match '/payments/receipt', to: 'payments#receipt', as: 'payments_receipt', via: [:get]
  authenticated :user, lambda {|u| u.admin?} do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  resources :payments, except: [:edit, :destroy] do
    get :paypal_success, on: :member
    get :paypal_cancel, on: :member
  end
  get '/notification' => 'payments#twocheckout_notification'
  devise_for :users
  root 'payments#new'
end
