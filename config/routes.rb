Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      post "users" => "users#create", as: :register
      get "users" => "users#index", as: :users

      scope "/auth", controller: :authentication do
        post "/login" => :login
        get "/logged_in" => :logged_in
        get "/logout" => :logout
      end

      resources :bucketlists do
        resources :items
      end

    end
  end
  get "/", :to => redirect("/api/docs/index.html")
end
