Rails.application.configure do
  config.action_mailer.perform_caching = false
  config.active_record.cache_versioning = false
  config.active_record.dump_schema_after_migration = false
  config.active_storage.service = :local
  config.active_support.deprecation = :notify
  config.cache_classes = true
  config.cache_store = :redis_store
  config.consider_all_requests_local = false
  config.eager_load = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
end
