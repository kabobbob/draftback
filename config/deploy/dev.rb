load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, 'draftback'
set :repository, 'git@t-rac:draftback.git'
set :scm, 'git'
set :user, 'kabob'
set :deploy_to, "/home/www/#{application}"
set :deploy_via, :copy
set :use_sudo, false

role :app, 'gnash'

after "deploy:update", "config:bundle"

namespace :config do
#  task :symlink do
#    run "ln -sfn /home/#{user}/Artemis/shared/xapable #{release_path}/xapable"  
#    run "ln -sfn #{shared_path}/config/source_db.yml #{release_path}/config/source_db.yml"
#    run "ln -sfn #{shared_path}/config/destination_db.yml #{release_path}/config/destination_db.yml"  
#  end

  task :bundle do 
    run "cd #{current_path} && bundle install --path #{shared_path}/bundle"
  end
end

namespace :deploy do
  task :finalize_update do
  end

  task :restart do 
  end 
end
