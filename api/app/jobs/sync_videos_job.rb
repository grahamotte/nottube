class SyncVideosJob < ApplicationJob
  def perform(subscription_id)
    sub = Subscription.find_by!(id: subscription_id)

    sub.yt_videos.first(sub.look_back_count).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: sub)
      v.refresh_metadata
    end

    # mark for downloading
    all = sub.reload.videos
    to_keep = all.last(sub.keep_count)
    to_keep.each { |v| v.update!(to_download: true) }
    (all - to_keep).each { |v| v.update!(to_download: false) }
  end
end
