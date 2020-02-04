class DownloadVideoJob < ApplicationJob
  def perform(remote_id)
    Video.find_by!(id: remote_id).download!
  end
end
