Yt.configure do |config|
  config.api_key = Rails.application.credentials.youtube_api
  config.log_level = :debug
end
