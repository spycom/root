Game::Application.routes.draw do
  get "bot/index"

  get "game/index"

  get "home/index"
	

#resources :game
match 'game' => 'game#index'
match 'game/start' => 'game#index', :task => 'start'

match 'game/job' => 'game#job'
match 'game/job/add' => 'game#job', :task => 'add'
match 'game/job/:id' => 'game#job', :task => 'new'

match 'game/hard' => 'game#hard'
match 'game/hard/add' => 'game#hard', :task => 'add'
match 'game/hard/:id' => 'game#hard', :task => 'new'


match 'game/soft' => 'game#soft'
match 'game/soft/add' => 'game#soft', :task => 'add'
match 'game/soft/:id' => 'game#soft', :task => 'new'

match 'game/db' => 'game#db'
#match 'game/db' => 'game#db'

match 'game/quests' => 'game#quests'

match 'game/uplink' => 'game#uplink'
match 'game/uplink/:id' => 'game#uplink', :task => 'connect'

match 'game/ip' => 'game#ip'

match 'game/domain' => 'game#domain'
match 'game/domain/:id' => 'game#domain', :task => 'connect'

match 'game/attack' => 'game#attack'
match 'game/attack/:id' => 'game#attack', :task => 'attack'

match 'game/attack_user' => 'game#attack_user', :id => 0
match 'game/attack_user/:id' => 'game#attack_user'
match 'game/attack_user/:id/fight' => 'game#attack_user', :task => 'fight'

match 'game/infect/:id' => 'game#infect'
match 'game/infect_bot/:id' => 'game#infect_bot'

match 'game/evolve' => 'game#evolve'
match 'game/evolve/:id' => 'game#evolve', :task => 'evolve'

match 'game/research' => 'game#research'
match 'game/research/:id' => 'game#research'

match 'game/services' => 'game#services'
match 'game/services/add' => 'game#services', :task => 'add'
match 'game/services/:id' => 'game#services'

match 'game/bots' => 'game#bots'

match 'game/attack_bot/:id' => 'game#attack_bot'
match 'game/attack_bot/:id/fight' => 'game#attack_bot', :task => 'fight'


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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
