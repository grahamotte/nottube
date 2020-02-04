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

class Video < ApplicationRecord
  belongs_to :subscription

  default_scope { order('published_at desc') }
  scope :downloaded, -> { where(downloaded: true) }

  def execute_download
    raise 'implement me'
  end

  def refresh_metadata
    raise 'implement me'
  end

  def videos_dir
    Setting.instance.videos_path || Rails.root.join('videos').to_s
  end

  def derived_title
    "#{subscription.title || 'No Sub'} - #{title || 'No Title'} - #{remote_id || 'No Id'}"
  end

  def video_formats
    ["mp4", 'mkv', 'avi', 'm4a']
  end

  def default_file_path
    File.join(videos_dir, "#{derived_title}.#{video_formats.first}")
  end

  def possible_file_paths
    [
      read_attribute(:file_path),
      *video_formats.map { |fmt| File.join(videos_dir, "#{derived_title}.#{fmt}") }
    ].compact
  end

  def file_path
    possible_file_paths.find { |fp| File.exists?(fp) }
  end

  def scheduled?
    return false if downloaded?
    return false if subscription.videos_to_keep.exclude?(self)

    true
  end

  def file_exists?
    return false if file_path.blank?
    File.exists?(file_path)
  end

  def watchable?
    downloaded? && file_exists?
  end

  def download!
    return false if downloaded?
    return false unless scheduled?

    FileUtils.mkdir_p(videos_dir)

    execute_download

    update!(file_path: file_path, downloaded: true) if file_exists?
  end

  def remove!
    File.delete(file_path) if file_exists?
    update!(downloaded: false, file_path: nil)
  end
end
