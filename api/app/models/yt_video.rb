# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  remote_id       :string
#  published_at    :datetime
#  title           :string
#  thumbnail_url   :string
#  file_path       :string
#  description     :text
#  duration        :integer
#  downloaded      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string           default("YtVideo")
#

class YtVideo < Video
  def execute_download
    system(
        [
        "youtube-dl",
        remote_id,
        "-o \"#{default_file_path(nil)}.%(ext)s\"",
        "--write-thumbnail",
      ].join(' ')
    )
  end

  def refresh_metadata
    yt_video = Yt::Video.new(id: remote_id)

    update!(
      published_at: yt_video.published_at,
      title: yt_video.title,
      thumbnail_url: yt_video.thumbnail_url(:high),
      description: yt_video.description,
      duration: yt_video.duration,
    )
  end
end
