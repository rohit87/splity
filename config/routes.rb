Splity::Application.routes.draw do
  
  resources :users do

    member do
      get :friends
      post :friends, :unfriend
    end

    match "/patch" => "users#patch", via: [:post], as: "patch_user"

    resources :activities
    match "/activities/new" => "activities#create", via: [:post], as: "create_activity"
  end

  match "/login" => "users#authenticate", via: [:get, :post], as: "signin"
  match "/login_app" => "users#authenticate_via_app", via: [:get, :post], as: "authenticate_via_app"
  match "auth/:provider/callback" => "users#authenticate_via_facebook", via: [:get, :post], as: "authenticate_via_facebook"
  match "/logout" => "users#logout", via: :get, as: "logout"
  match "/users/:id/destroy" => "users#destroy", via: [:get], as: "destroy_user"

  # notifications
  match "/notifications_lightbox/" => "notifications#all_notifications_lightbox", via: :get, as: "notifications_lightbox"
  match "/notification/read/:notification_id" => "notifications#read_notification", via: :get, as: "notification_read"

  match "/" => "users#home", via: [:get], as: "root"

  # Various Rack Applications
  mount Resque::Server, at: "/resque"
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
