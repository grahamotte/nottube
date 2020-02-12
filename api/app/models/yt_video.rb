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

class YtVideo < Video
  def execute_download
    execute(
      "youtube-dl",
      "ytsearch:#{remote_id}",
      "-o \"#{default_file_path(nil)}.%(ext)s\"",
      "--write-thumbnail",
    )
  end

  def refresh_metadata
    data = execute("youtube-dl", '-j', "ytsearch:#{remote_id}")
      .then { |x| JSON.parse(x).deep_symbolize_keys }

    update!(
      published_at: data.dig(:upload_date),
      title: data.dig(:title),
      thumbnail_url: data.dig(:thumbnail),
      description: data.dig(:description),
      duration: data.dig(:duration),
    )
  end
end
