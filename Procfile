api: cd api && bundle exec rails server --port 3000
worker_1: cd api && rails runner 'Delayed::Worker.new.start'
worker_2: cd api && rails runner 'Delayed::Worker.new.start'
clock: cd api && clockwork clock.rb
client: cd client && export PORT=3001 && npm run start
