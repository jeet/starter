set :application, "starter"
set :deploy_to, "/var/www/rails_applications"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git://github.com/jeet/starter.git"
set :branch, "master"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, "192.168.1.22"                          # Your HTTP server, Apache/etc
role :web, "192.168.1.22"                          # This may be the same as your `Web` server
role :db,  "192.168.1.22", :primary => true		   # This is where Rails migrations will run

set :user, "root"
set :password, "advent@123"
set :port, "22"


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
  [:stop, :start, :restart].each do |t|
	desc "#{t.to_s.capitalize} server"
	task t, :roles => :app do
	  invoke_command "cd #{deploy_to}/current; RAILS_ENV=production bundle install --relock"
 	end
  end
end
namespace :passenger do
  desc "Restart Application"
  task :restart do
	run "touch #{current_path}/tmp/restart.txt"
  end
end
after "deploy:restart", "passenger:restart"