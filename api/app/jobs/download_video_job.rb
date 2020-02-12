class DownloadVideoJob < ApplicationJob
  def perform(remote_id)
    v = Video.find_by!(id: remote_id)
    v.download!
    v.touch
    v.subscription.touch
  end
end
