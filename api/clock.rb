require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Clockwork
  every(30.minutes, 'sync_most_recent_videos') { SyncMostRecentVideosJob.perform_later }
end
