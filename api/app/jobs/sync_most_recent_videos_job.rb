class SyncMostRecentVideosJob < ApplicationJob
  def perform
    Subscription
      .all
      .each { |s| SyncJob.perform_later(s.id, look_back: 2) }
  end
end
