class SubscriptionsController < ApplicationController
  def create
    s = Subscription.create!(url: params.require(:url), keep_count: 2)
    s.refresh_metadata
    SyncVideosJob.perform_later(s.id)

    head :ok
  end

  def sync
    SyncVideosJob.perform_later(
      Subscription.find_by!(id: params.require(:id)).id
    )

    head :ok
  end

  def sync_all
    SyncMostRecentVideosJob.perform_later

    head :ok
  end

  def destroy
    s = Subscription.find_by!(id: params.require(:id))
    s.videos.where(downloaded: true).each { |v| v.remove! }
    s.reload.videos.each { |v| v.destroy! }
    s.destroy!

    head :ok
  end

  def index
    render json: (
      Subscription
        .all
        .includes(:videos)
        .sort_by(&:updated_at)
        .reverse
        .map do |s|
          s.attributes.merge(
            videos_downloaded: s.videos.count(&:downloaded?),
            videos_scheduled: s.videos.count(&:scheduled?),
          )
        end
    )
  end
end
