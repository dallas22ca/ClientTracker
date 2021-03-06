require "sidekiq/web"

Rem::Application.routes.draw do
  
  devise_for :users
  
  get "/events/img/:args" => "events#img", as: :event_img, format: :gif
  get "/events/redirect/:args" => "events#img", as: :event_redirect, format: :gif
  get "/events/analysis" => "events#analysis", as: :event_analysis
  get "/import" => "import#upload", as: :import
  match "/import/processing" => "import#processing", via: [:get, :patch], as: :import_processing
  post "/contacts/save" => "contacts#save", as: :save_contact
  post "/contacts/overwrite" => "contacts#overwrite", as: :overwrite_contact
  get "/contacts/overview" => "overview#contacts", as: :contacts_overview
  get "/subscriptions/:token" => "subscriptions#index", as: :subscribe
  
  resources :segments do
    resources :contacts, only: [:index]
    resources :events, only: [:index]
  end
  
  resources :contacts do
    resources :events, only: [:index, :show]
  end
  
  resources :graphs
  resources :messages
  resources :events, only: [:index, :create]
  
  authenticated :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root "overview#index"
  
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
