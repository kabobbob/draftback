set :application, 'draftback'
set :repository,  "git@t-rac:draftback.git"
set :rails_env, 'staging'
set :scm, :git
set :user, 'www'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy
set :use_sudo, false

role :web, '174.143.244.245'
role :app, '174.143.244.245'

after "deploy:update", "config:symlink", "config:bundle"

namespace 'config' do
  task :symlink do
    run "ln -nfs #{current_path}/public /home/www/www-home/current/public/#{application}"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/bundle #{release_path}/vendor/bundle"
  end

  task :bundle do
    run "cd #{current_path} && bundle install --path=#{release_path}/vendor/bundle --without development"
  end
end

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  desc 'restart the app'
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end
end
