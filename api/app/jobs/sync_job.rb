class SyncJob < ApplicationJob
  def perform(subscription_id)
    s = Subscription.find_by!(id: subscription_id)
    s.configure_for_me
    s.refresh_metadata

    s.remote_video_ids(Setting.instance.look_back_count).each do |vid|
      v = s.video_class.find_or_create_by(remote_id: vid, subscription: s)
      v.refresh_metadata
    end

    s.reload.videos_to_keep.each { |v| DownloadVideoJob.perform_later(v.id) }
    (s.videos - s.videos_to_keep).each { |v| v.remove! }
    s.reload.touch
  end
end
