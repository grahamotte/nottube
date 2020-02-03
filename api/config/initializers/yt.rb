Yt.configure do |config|
  config.log_level = :debug
end

ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  Rails.logger.info(args)
end
