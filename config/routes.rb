Rails.application.routes.draw do
  resources :vehicles
  resources :customers

  resources :services
  
  get 'pages/home'
  get 'pages/services'
  get 'pages/customers'
  get 'search', to:"logs#search" 
  resources :logs
  
  root to: 'pages#home'
end
