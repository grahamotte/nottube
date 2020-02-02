class VideosController < ApplicationController
  def index
    render json: Subscription
      .find_by!(id: params.require(:subscription_id))
      .videos.map do |v|
        {
          id: v.id,
          subscription_id: v.subscription_id,
          video_id: v.video_id,
          title: v.title,
          thumbnail_url: v.thumbnail_url,
          file_path: v.file_path,
          description: v.description,
          duration: v.duration,
          downloaded: v.downloaded,
          scheduled: v.scheduled?,
          published_at: v.published_at.in_time_zone('UTC').iso8601,
          created_at: v.created_at.in_time_zone('UTC').iso8601,
          updated_at: v.updated_at.in_time_zone('UTC').iso8601,
        }
      end
  end
end
