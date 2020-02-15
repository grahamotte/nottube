class SyncJob < ApplicationJob
  def perform(subscription_id)
    # refresh sub
    s = Subscription.find_by!(id: subscription_id)
    s.configure_for_me
    s.refresh_metadata

    # look for new videos
    s.remote_video_ids(Setting.instance.look_back_count).each do |vid|
      v = s.video_class.find_or_create_by(remote_id: vid, subscription: s)
      v.refresh_metadata
    end

    # download new videos
    s
      .reload
      .videos_to_keep
      .reject(&:downloaded?)
      .each { |v| DownloadVideoJob.perform_later(v.id) }

    # remove old ones
    (s.videos - s.videos_to_keep).each { |v| v.remove! }

    # done!
    s.reload.touch
  end
end
