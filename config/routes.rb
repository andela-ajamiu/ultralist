Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :users, only: :create

      resources :bucketlists do
        resources :items
      end

      scope "/auth", controller: :sessions do
        get '/logout' => :logout
        post '/login' => :login
      end

    end
  end
end
