Rails.application.routes.draw do
  devise_for :users
  scope '/api' do
    resources :games, only: [:create]
  end
end
