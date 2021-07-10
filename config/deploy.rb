# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '3.16.0'

set :application, 'kontes-terbuka'
set :repo_url, 'git@github.com:donjar/kontes-terbuka.git'
set :branch, 'production'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ktom/kontes-terbuka'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, [])
  .push('config/database.yml', 'config/secrets.yml', 'config/unicorn.rb',
        'config/initializers/line_targets.rb', '.env',
        'app/views/contests/certificate.tex.haml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache',
                                               'tmp/sockets', 'vendor/bundle',
                                               'public/system',
                                               'public/contest_files')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, forward_agent: true, port: 1729
set :rails_env, 'production'

namespace :deploy do
  desc 'Restart application two times'
  task :restart_twice do
    2.times do
      on roles(:app) do
        upload! StringIO.new(File.read('config/deploy/restart.sh')),
                "#{deploy_to}/restart.sh"
        execute :chmod, "u+x #{deploy_to}/restart.sh"
        execute "sudo #{deploy_to}/restart.sh"
      end
    end
  end

  after :publishing, 'deploy:restart_twice'
  after :finishing, 'deploy:cleanup'
  after :finishing, 'sitemap:refresh'
end
