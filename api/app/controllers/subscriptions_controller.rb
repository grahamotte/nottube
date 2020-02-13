class SubscriptionsController < ApplicationController
  def create
    unless subscription_class.present?
      render json: { error: 'Unsupported subscription host' }
      return
    end

    s = subscription_class.create!(url: url_param)
    SyncJob.perform_later(s.id)

    head :ok
  end

  def sync
    SyncJob.perform_later(
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
    s.videos.select { |v| v.file_exists? }.each { |v| v.remove! }
    s.reload.videos.each { |v| v.destroy! }
    s.destroy!

    head :ok
  end

  def index
    render json: Subscription
      .all
      .includes(:videos)
      .map(&:serialize)
  end

  private

  def url_param
    params.require(:url)
  end

  def subscription_class
    host = URI(url_param).host

    return YtSubscription if host.include?('youtube.com')
    return NebulaSubscription if host.include?('watchnebula.com')
  end
end
