Rails.application.routes.draw do

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do

      resources :users, only: [:create, :index]

      scope "/auth", controller: :authentication do
        get '/logout' => :logout
        post '/login' => :login
      end

      resources :bucketlists do
        resources :items
      end

    end
  end
end
