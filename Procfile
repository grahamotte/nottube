api: cd api && bundle exec rails server --port 3000 -b 0.0.0.0
client: cd client && export PORT=3030 && export HOST=0.0.0.0 && npm run start
clock: cd api && bundle exec clockwork clock.rb
worker_a: cd api && bundle exec rails runner 'Delayed::Worker.new.start'
worker_b: cd api && bundle exec rails runner 'Delayed::Worker.new.start'
worker_c: cd api && bundle exec rails runner 'Delayed::Worker.new.start'
