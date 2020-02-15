class SyncMostRecentVideosJob < ApplicationJob
  def perform
    Subscription
      .all
      .shuffle
      .each { |s| SyncJob.perform_later(s.id) }
  end
end
