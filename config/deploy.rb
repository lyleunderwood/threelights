#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require "bundler/capistrano"

set :rvm_ruby_string, '1.9.2@threelights'
set :rvm_type, :user
#set :rvm_bin_path, "/usr/local/rvm/bin"
#set :rvm_path, "/usr/local/rvm"
require "rvm/capistrano"

set :application, "threelights"
set :repository,  "git@github.com:lyleunderwood/threelights.git"
set :scm, :git
set :branch, "master"

set :rails_env, "production"
set :deploy_env, "production"
set :unicorn_env, "production"

server "three-lights.net", :app, :web, :db, :primary => true

set :deploy_to, "/var/threelights"

set :use_sudo, false
set :user, 'ubuntu'

#role :web, "staging.hurley.elasticsuite.com"
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

task :build_dirs, :roles => [:app, :web] do
  run "mkdir #{release_path}/tmp/sockets"
end

after "deploy:update_code", :build_dirs

after('deploy:update_code', 'assets:precompile')

namespace :assets do
  desc 'Precompile assets'
  task :precompile, :roles => :app do
    run "cd #{release_path}; bundle exec rake assets:precompile RAILS_ENV=production"
  end
end

require 'capistrano-unicorn'
