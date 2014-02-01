load 'deploy/assets'

require "bundler/capistrano"
require 'sidekiq/capistrano'
require "whenever/capistrano"
require 'capistrano-unicorn'

set :application, "remetric"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :workers, { '*' => 3 }

set :scm, "git"
set :repository, "git@github.com:dallas22ca/#{application}.git"

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)
set :whenever_command, "bundle exec whenever"

set :server_name, "107.170.24.138"
set :rails_env, "production"
set :branch, "master"
set :root_url, "https://www.netbuild.co"
server server_name, :web, :app, :db, primary: true
set :whenever_command, "bundle exec whenever"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

Dir.glob("config/recipes/*.rb").each do |file|
  load file
end

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"
after "deploy:install", "deploy:autoremove"