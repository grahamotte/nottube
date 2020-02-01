class SyncVideosJob < ApplicationJob
  def perform(subscription_id, look_back: 3)
    # setup vars
    s = Subscription.find_by!(id: subscription_id)
    keep ||= s.keep_count

    # pull videos from YT and save their metadata
    s.yt_videos.first(look_back).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: s)
      v.refresh_metadata
    end

    # get current state of videos
    all = s.reload.videos
    to_keep = s.videos_to_keep
    to_remove = (all - to_keep)

    # ensure everything marked as downloaded is actually downloaded
    all.each { |v| v.update!(downloaded: false) unless v.file_exists? }

    # cleanup and schedule downloads for ones tos keep
    to_keep.reject(&:watchable?).each { |v| DownloadVideoJob.perform_later(v.id) }

    # remove the ones not staged to keep
    to_remove.each { |v| v.remove! }

    # touch to show that it was updated
    s.reload.touch
  end
end
