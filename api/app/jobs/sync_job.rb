class SyncJob < ApplicationJob
  def perform(subscription_id, look_back: 8)
    s = Subscription.find_by!(id: subscription_id)
    s.configure_for_me
    s.refresh_metadata

    # ensure everything marked as downloaded is actually downloaded
    s.videos.each { |v| v.update!(downloaded: false) unless v.file_exists? }

    # pull videos and some of their metadata
    s.remote_video_ids.first(look_back).each do |vid|
      v = s.video_class.find_or_create_by(remote_id: vid, subscription: s)
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
