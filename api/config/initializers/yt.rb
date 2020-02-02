Yt.configure do |config|
  config.log_level = :debug
end

Rails.configuration.after_initialize do
  Setting.configure_yt
end

ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  Rails.logger.info(args)
end
