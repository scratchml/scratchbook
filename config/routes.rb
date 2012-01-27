Scratchbook::Application.routes.draw do

  get '/data' => 'scratches#index', :as => :data
  post '/data' => 'scratches#create'
  get '/data/:id' => 'scratches#show', :as => :scratch
  delete '/data/:id' => 'scratches#destroy'
  # put '/data/:id' => 'scratches#update'


  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "signup" }

  get '/about' => 'home#about', :as => :about
  get '/contact' => 'home#contact', :as => :contact

  get '/settings' => 'users#settings', :as => :settings
  get '/:id' => 'users#show', :as => :user

  # root :to => 'home#frontpage'
  root :to => 'scratches#index'

  # match ':controller(/:action(/:id(.:format)))'
end
