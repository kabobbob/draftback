ActionController::Routing::Routes.draw do |map|

  map.resource :petition, :member => {:sign => :get, :submit => :post}

  map.connect '', :controller => 'main', :action => 'index'

  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
