class SyncVideosJob < ApplicationJob
  def perform(subscription_id, look_back: nil, keep: nil)
    # setup vars
    s = Subscription.find_by!(id: subscription_id)
    look_back ||= s.look_back_count
    keep ||= s.keep_count

    # pull videos from YT and save their metadata
    s.yt_videos.first(look_back).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: s)
      v.refresh_metadata
    end

    # mark videos which should be downloaded
    all = s.reload.videos
    to_keep = all.first(keep)
    to_keep.each { |v| v.update!(to_download: true) }
    to_keep.each { |v| DownloadVideoJob.perform_later(v.id) }

    # mark which should no longer be downloaded
    (all - to_keep).each { |v| v.update!(to_download: false) }
    # TODO remove old vids
  end
end
