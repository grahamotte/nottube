class SyncVideosJob < ApplicationJob
  def perform(subscription_id, look_back: 3)
    s = Subscription.find_by!(id: subscription_id)

    # ensure everything marked as downloaded is actually downloaded
    s.videos.each { |v| v.update!(downloaded: false) unless v.file_exists? }

    # pull videos from YT and save their metadata
    s.yt_videos.first(look_back).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: s)
      v.refresh_metadata
      v.touch
    end

    # reload
    s.reload

    # schedule new downloads
    s.videos_to_keep.each { |v| DownloadVideoJob.perform_later(v.id) }

    # remove old ones
    (s.videos - s.videos_to_keep).each { |v| v.remove! }

    # touch
    s.reload.touch
  end
end
