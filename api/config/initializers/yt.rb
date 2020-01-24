Yt.configure do |config|
  config.api_key = ENV['PLEXTUBE_YOUTUBE_API_KEY']&.chomp&.strip
  config.log_level = :debug
end

ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  Rails.logger.info(args)
end
