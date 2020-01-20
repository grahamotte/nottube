class DownloadVideoJob < ApplicationJob
  def perform(video_id)
    v = Video.find_by!(id: video_id)
    s = v.subscription

    return if v.downloaded
    return unless v.to_download

    root_dir = Rails.application.credentials.videos_path
    FileUtils.mkdir_p(root_dir)

    file_name = "#{s.title} - #{v.title} - #{v.video_id}.mp4"
    full_file_path = "#{root_dir}/#{file_name}"

    opts = [
      "youtube-dl",
      v.video_id,
      "-o \"#{full_file_path}\"",
      "--write-thumbnail"
    ]

    system(opts.join(' '))
  end
end
