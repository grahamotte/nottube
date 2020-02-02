Yt.configure do |config|
  config.log_level = :debug
end

Setting.configure_yt if ActiveRecord::Base.connection.table_exists?('settings')

ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  Rails.logger.info(args)
end
