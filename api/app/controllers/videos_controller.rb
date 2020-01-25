class VideosController < ApplicationController
  def index
    render json: Subscription
      .find_by!(id: params.require(:subscription_id))
      .videos.map do |v|
        {
          id: v.id,
          subscription_id: v.subscription_id,
          video_id: v.video_id,
          published_at: v.published_at,
          title: v.title,
          thumbnail_url: v.thumbnail_url,
          file_name: v.file_name,
          description: v.description,
          duration: v.duration,
          downloaded: v.downloaded,
          created_at: v.created_at,
          updated_at: v.updated_at,
          scheduled: v.scheduled?,
        }
      end
  end
end
