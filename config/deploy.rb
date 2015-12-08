set :application, "CaowuLoyalty"
set :repository,  "git@github.com:oeddyo/CaowuLoyalty.git"
set :deploy_to, "/var/www/#{application}" #path to your app on the production server 

set :scm, :git
set :branch, "master"
set :deploy_via, :copy
set :shallow_clone, 1

set :user, "deploy"
set :use_sudo, false

role :web, "198.199.118.29"                          # Your HTTP server, Apache/etc
role :app, "198.199.118.29"                          # This may be the same as your `Web` server
role :db,  "198.199.118.29", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

after "deploy:setup", "db_yml:create"
after "deploy:update_code", "db_yml:symlink"

namespace :db_yml do
  desc "Create database.yml in shared path" 
  task :create do
    config = {
              "production" => 
              {
                "adapter" => "mysql2",
                "pool" => 5,
                "timeout" => 5000,
                "username" => "root",
                "password" => "root",
                "database" => "#{application}_production"
              }
            }
    put config.to_yaml, "#{shared_path}/database.yml"
  end

  desc "Make symlink for database.yml" 
  task :symlink do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml" 
  end
end


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
