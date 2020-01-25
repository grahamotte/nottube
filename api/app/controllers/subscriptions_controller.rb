class SubscriptionsController < ApplicationController
  def create
    s = Subscription.create!(url: params.require(:url), keep_count: 2)
    s.refresh_metadata
    SyncVideosJob.perform_later(s.id)

    head :ok
  end

  def index
    render json: Subscription.all.sort_by(&:updated_at).reverse.map(&:attributes)
  end
end
