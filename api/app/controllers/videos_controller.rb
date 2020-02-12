class VideosController < ApplicationController
  def index
    render json: (
      Subscription
        .find_by!(id: params.require(:subscription_id))
        .videos
        .map(&:serialize)
    )
  end
end
