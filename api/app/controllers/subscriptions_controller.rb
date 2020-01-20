class SubscriptionsController < ApplicationController
  def create
    s = Subscription.create!(channel_url: params.require(:url))
    s.refresh_metadata

    head :ok
  end

  def index
    render json: Subscription.all.map(&:attributes)
  end
end
