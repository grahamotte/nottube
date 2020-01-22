class RefreshSubscriptionMetadataJob < ApplicationJob
  def perform
    Subscription
      .all
      .each { |r| r.refresh_metadata }
  end
end
