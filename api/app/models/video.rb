# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  video_id        :string
#  published_at    :datetime
#  title           :string
#  thumbnail_url   :string
#  file_name       :string
#  description     :text
#  duration        :integer
#  downloaded      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Video < ApplicationRecord
  belongs_to :subscription

  default_scope { order('published_at desc') }
  scope :downloaded, -> { where(downloaded: true) }

  def file_name
    read_attribute(:file_name) || derived_file_name
  end

  def derived_file_name
    "#{subscription.title || 'No Sub'} - #{title || 'No Title'} - #{video_id || 'No Id'}"
  end

  def video_formats
    ["mp4", 'mkv', 'avi']
  end

  def videos_dir
    Setting.instance.videos_path || Rails.root.join('videos')
  end

  def path
    video_formats.find do |fmt|
      File.join(videos_dir, "#{file_name}.#{fmt}")
    end
  end

  def scheduled?
    return false if downloaded?
    return false if subscription.videos_to_keep.exclude?(self)

    true
  end

  def watchable?
    downloaded? && file_exists?
  end

  def file_exists?
    File.exists?(path)
  end

  def download!
    return false if downloaded?
    return false unless scheduled?

    update!(file_name: nil)

    FileUtils.mkdir_p(videos_dir)

    system(
      [
        "youtube-dl",
        video_id,
        "-o \"#{path}.#{video_formats.first}\"",
        "--write-thumbnail"
      ].join(' ')
    )

    update!(file_name: file_name, downloaded: true) if file_exists?
  end

  def remove!
    File.delete(path) if file_exists?
    update!(downloaded: false, file_name: nil)
  end

  def yt_video
    @yt_video ||= Yt::Video.new(id: video_id)
  end

  def refresh_metadata(vid = nil)
    @yt_video = vid if vid

    update!(
      published_at: yt_video.published_at,
      title: yt_video.title,
      thumbnail_url: yt_video.thumbnail_url(:high),
      description: yt_video.description,
      duration: yt_video.duration,
    )
  end
end
