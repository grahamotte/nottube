class SyncVideosJob < ApplicationJob
  def perform(subscription_id)
    Rails.logger.info('started sync...')
    s = Subscription.find_by!(id: subscription_id)

    s.yt_videos.first(s.look_back_count).each do |v|
      v = Video.find_or_create_by(video_id: v.id, subscription: s)
      v.refresh_metadata
    end

    # mark for downloading
    all = s.reload.videos
    to_keep = all.first(s.keep_count)
    to_keep.each { |v| v.update!(to_download: true) }
    (all - to_keep).each { |v| v.update!(to_download: false) }

    # enqueue video download jobs
    Video.where(subscription: s, to_download: true).each do |v|
      DownloadVideoJob.perform_later(v.id)
    end
  end
end
