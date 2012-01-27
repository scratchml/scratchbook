Scratchbook::Application.routes.draw do

  resources :scratches

  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "signup" }

  get '/data' => 'scratches#index', :as => :scratches

  get '/about' => 'home#about', :as => :about
  get '/contact' => 'home#contact', :as => :contact

  get '/settings' => 'users#settings', :as => :settings
  get '/:id' => 'users#show', :as => :user

  root :to => 'home#frontpage'

  # match ':controller(/:action(/:id(.:format)))'
end
