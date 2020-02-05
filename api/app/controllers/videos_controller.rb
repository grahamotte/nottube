class VideosController < ApplicationController
  def index
    render json: (
      Subscription
        .find_by!(id: params.require(:subscription_id))
        .videos
        .map { |v| v.attributes.merge(scheduled: v.scheduled?) }
    )
  end
end
