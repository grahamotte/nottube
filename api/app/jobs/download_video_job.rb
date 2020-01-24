class DownloadVideoJob < ApplicationJob
  def perform(video_id)
    Video.find_by!(id: video_id).download!
  end
end
