Rails.application.routes.draw do
  post 'search', to: 'home#search', as: :search
  
  root to: "home#index"
end
