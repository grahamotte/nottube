require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Clockwork
  if ENV['ENABLE_CLOCK']
    every(6.hour, 'sync_most_recent_videos') { SyncMostRecentVideosJob.perform_later }
  end
end
