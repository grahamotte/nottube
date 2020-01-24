require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Clockwork
  every(1.hour, 'sync_most_recent_videos') { SyncMostRecentVideosJob.perform_later }
  every(1.hour, 'update_videos_status') { UpdateVideosStatusJob.perform_later }
  every(6.hours, 'refresh_subscription_metadata') { RefreshSubscriptionMetadataJob.perform_later }
end
