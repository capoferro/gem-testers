$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require "rvm/capistrano"

default_run_options[:pty] = true

set :use_sudo, false
set :sudo, "sudo -EH -u rails "
set :default_shell, "#{sudo} /usr/local/bin/rvm-shell '#{rvm_ruby_string}'"

set :application, "gem-testers"
set :repository,  "git://github.com/rubygems/gem-testers.git"
set :branch, "master"

set :deploy_to, "/opt/nginx/gem-testers/"
set :deploy_via, :remote_cache

set :scm, :git

role :web, "173.255.233.55"#"gem-testers.org"
role :app, "173.255.233.55"#"gem-testers.org"
role :db,  "173.255.233.55", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("#{try_sudo} mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && #{try_sudo} bundle install --without test"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'
