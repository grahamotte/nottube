# == Schema Information
#
# Table name: videos
#
#  id              :bigint           not null, primary key
#  subscription_id :integer
#  remote_id       :string
#  published_at    :datetime
#  title           :string
#  thumbnail_url   :string
#  file_path       :string
#  description     :text
#  duration        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string           default("YtVideo")
#

class Video < ApplicationRecord
  belongs_to :subscription

  default_scope { order('published_at desc') }

  def execute_download
    raise 'implement me'
  end

  def refresh_metadata
    raise 'implement me'
  end

  def serialize
    attributes
      .symbolize_keys
      .merge(
        scheduled: scheduled?,
        downloaded: file_exists?,
      )
  end

  def videos_dir
    '/opt/videos'
  end

  def derived_title
    clean_string("#{subscription.title || 'No Sub'} - #{title || 'No Title'} - #{remote_id || 'No Id'}")
  end

  def video_formats
    ["mp4", 'mkv', 'avi', 'm4a', 'webm']
  end

  def default_file_path(fmt = nil)
    File.join(videos_dir, [derived_title, fmt].compact.join('.'))
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
    return false if file_exists?
    return false if subscription.videos_to_keep.exclude?(self)

    true
  end

  def file_exists?
    return false if file_path.blank?
    File.exists?(file_path)
  end

  def download!
    return false if file_exists?
    return false unless scheduled?

    execute_download

    if file_exists?
      FileUtils.chmod(0777, file_path)
      update!(file_path: file_path)
      return true
    end

    false
  end

  def remove!
    File.delete(file_path) if file_exists?
    update!(file_path: nil)
  end

  private

  def clean_string(string)
    string
      .then { |s| ActiveStorage::Filename.new(s).sanitized }
      .gsub(/[^a-zA-Z0-9 -]/, '')
      .squish
  end
end
