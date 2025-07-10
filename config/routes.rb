Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :public do
    resources :players, only: %i[index show]
    resources :friends, only: :show
  end

  namespace :admin do
    resources :api_keys, only: %i[create show index destroy]
  end
end
