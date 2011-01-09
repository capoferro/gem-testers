# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'rake/remote_task'

GemTesters::Application.load_tasks

host "skirmisher.net", :app 

remote_task :setup_app, role: :app do
  set :sudo_password, 'Drac09jk'
  sudo 'uname -a'
end
