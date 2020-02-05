lock "~> 3.11.2"

set :application, "plextube"
set :deploy_to, "/home/me/plextube"
set :repo_url, "git@github.com:grahamotte/plextube.git"
set :branch, 'master'

set :default_environment, { 'PATH' => '$HOME/.rbenv/bin:$PATH' }
append :linked_files, "api/config/master.key", 'api/db/development.sqlite3', 'youtube_api_key'

desc 'start'
task :start do
  on roles(:all) do |host|
    eval_rbenv = "eval \"$(rbenv init -)\""

    execute "#{eval_rbenv}; cd #{current_path}; bundle"
    execute "#{eval_rbenv}; cd #{current_path}/api; bundle"
    execute "#{eval_rbenv}; cd #{current_path}/api; bundle exec rake db:create db:migrate"
    execute "cd #{current_path}/client; npm install"
    execute "killall screen" rescue nil
    execute <<~BASH
      screen -dmS plextube -L -Logfile #{current_path}/plextube.log bash -c '\
        #{eval_rbenv}; \
        cd #{current_path}; \
        export REACT_APP_API_BASE=http://#{host}; \
        export ENABLE_CLOCK=1; \
        foreman start \
      '
    BASH
  end
end

desc 'log'
task :log do
  on roles(:all) do |host|
    execute "tail -f #{current_path}/plextube.log"
  end
end
