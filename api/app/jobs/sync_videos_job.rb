class SyncVideosJob < ApplicationJob
  def perform(subscription_id, keep: 10)
    sub = Subscription.find_by!(id: subscription_id)

    sub.yt_videos.first(20).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: sub)
      v.refresh_metadata
    end

    # mark for downloading
    all = sub.reload.videos
    to_keep = all.sort_by(&:published_at).last(keep)
    to_remove = all - to_keep

    to_keep.each { |v| v.update!(to_download: true) }
    to_remove.each { |v| v.update!(to_download: false) }
  end
end
