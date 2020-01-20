api: cd api && bundle exec rails server --port 3000
job_worker_1: cd api && rails runner 'Delayed::Worker.new.start'
job_worker_2: cd api && rails runner 'Delayed::Worker.new.start'
job_worker_3: cd api && rails runner 'Delayed::Worker.new.start'
client: cd client && export PORT=3001 && npm run start
