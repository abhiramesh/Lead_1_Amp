Mortgage3::Application.routes.draw do
  
  devise_for :users, :controllers => { :registrations => "registration" } do
      get '/logout' => 'devise/sessions#destroy', :as => "destroy_user_session"
  end

  resources :users

  root to: 'static_pages#home'

  get '/thanks', to: 'static_pages#thanks'
  get '/privacy', to: 'static_pages#privacy'
  get '/nj', to: 'static_pages#nj'

  get '/extrainfo1', to: 'users#extra_info'
  get '/extrainfo2', to: 'users#extra_info_2'

  post '/users/:id', to: 'users#update'

  get '/vpujji1234', to: 'users#results'
  # get '/csvi', to: 'users#csvi'
  get '/about_us', to: 'static_pages#about_us'
  get '/fees', to: 'static_pages#fees'

  # post '/checkzip', to: 'users#checkzip'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
