application = 'research-ide'

set :keep_releases, 3

set :application, application
set :repo_url, "git@github.com:WorkflowsOnRails/#{application}.git"
set :scm, :git
set :branch, 'master'

set :deploy_to, "/srv/#{application}"

set :rails_env, 'staging'
set :migration_role, 'db'


namespace :deploy do
  desc 'Export supervisord configuration'
  task :foreman do
    on roles(:app), in: :groups do
      within release_path do
        execute :bundle,
                "exec foreman export supervisord supervisor",
                "--template #{release_path}/lib/supervisord_templates",
                "--log #{release_path}/supervisor/log",
                "--app application",
                "--env #{shared_path}/.env"
      end
    end
  end

  after 'deploy:updated', 'deploy:foreman'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :kill, "-HUP `cat #{deploy_path}/supervisord.pid`"
    end
  end

  after 'deploy:foreman', 'deploy:restart'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
