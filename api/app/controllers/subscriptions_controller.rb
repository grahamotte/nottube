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

  def destroy
    s = Subscription.find_by!(id: params.require(:id))
    s.videos.where(downloaded: true).each { |v| v.remove! }
    s.reload.videos.each { |v| v.destroy! }
    s.destroy!

    sleep 2

    head :ok
  end

  def index
    render json: Subscription.all.sort_by(&:updated_at).reverse.map(&:attributes)
  end
end
