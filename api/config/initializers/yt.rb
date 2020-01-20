Yt.configure do |config|
  config.api_key = Rails.application.credentials.youtube_api
  config.log_level = :debug
end

ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  Rails.logger.info(args)
end
