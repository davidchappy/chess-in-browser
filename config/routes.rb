Rails.application.routes.draw do
  devise_for :users
  scope '/api' do
    resources :games, only: [:create, :show, :update]
  end
end
