Rails.application.routes.draw do

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do

      resources :users, only: [:create, :index]

      scope "/auth", controller: :authentication do
        post '/login' => :login
        get '/logged_in' => :logged_in
        get '/logout' => :logout
      end

      resources :bucketlists do
        resources :items
      end

    end
  end
end
