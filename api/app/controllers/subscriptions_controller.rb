class SubscriptionsController < ApplicationController
  def create
    s = Subscription.create!(url: params.require(:url))
    s.refresh_metadata
    SyncVideosJob.perform_later(s.id)

    head :ok
  end

  def index
    render json: Subscription.all.map(&:attributes)
  end
end
