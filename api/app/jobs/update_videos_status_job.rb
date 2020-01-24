class UpdateVideosStatusJob < ApplicationJob
  def perform
    Video.all.each do |v|
      v.update!(downloaded: false) if v.downloaded? && !v.exists?
      v.update!(downloaded: true, to_download: false) if v.exists? && v.to_download?

      DownloadVideoJob.perform_later(v.id) if v.to_download?
    end

    Subscription.all.each do |s|
      downloaded = s.videos.downloaded
      keep = downloaded.first(s.keep_count)

      (downloaded - keep).each { |v| v.remove! }
    end
  end
end
