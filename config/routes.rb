ActionController::Routing::Routes.draw do |map|
  map.resources :links, :collection => {:manage => :get}, :member => {:toggle_displayed => :get}

  map.resources :posts, :collection => {:archive => :get}, :member => {:full => :get, :toggle_displayed => :get}

  map.resource :user_session

  map.resources :users

  map.resource :petition, :member => {:sign => :get, :submit => :post, :signatures => :get, :manage => :get}

  map.manage  '/manage',  :controller => 'main', :action => 'manage'
  map.contact '/contact', :controller => 'main', :action => 'contact'
  
  map.root    :controller => 'main', :action => 'index'
  
  # map route for archives
  map.connect ':controller/:action/:year/:month'
end
