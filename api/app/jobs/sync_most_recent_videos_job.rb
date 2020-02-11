class SyncMostRecentVideosJob < ApplicationJob
  def perform
    Subscription
      .all
      .shuffle # yt api limits are absurdly low, randomly load this so if we have no more creds everyone has a chance
      .each { |s| SyncJob.perform_later(s.id, look_back: 2) }
  end
end
