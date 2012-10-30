Fiskregn::Application.routes.draw do

  # Localise all and everything
  scope '(:locale)' do
    get "home/index"
  
    # Viewing of generic content
    get "contents/:id" => 'contents#show', as: 'content'

    # Tagging of content
    put "contents/:id/tag" => 'contents#tag', as: 'tag_content'

    # Enabling publishing of (generic) content to a location
    get "contents/:id/publish" => 'contents#publish', as: 'publish_content'
    put "contents/:id/publish" => 'contents#publish', as: 'publish_content'
    # Enabling withdrawing of (generic) content to a location
    get "contents/:id/withdraw" => 'contents#withdraw', as: 'withdraw_content'
    put "contents/:id/withdraw" => 'contents#withdraw', as: 'withdraw_content'

    # CRUD for TextContent
    resources :text_contents

    get "/home" => 'users#home'
    
    devise_for :users
    resources :users
  
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
    # just remember to delete public/in_dex.html.
    # root :to => 'welcome#index'
  
    # See how all your routes lay out with "rake routes"
  
    # This is a legacy wild controller route that's not recommended for RESTful applications.
    # Note: This route will make all actions in every controller accessible via GET requests.
    # match ':controller(/:action(/:id))(.:format)'

    root :to => "home#index"
    
  end

end
