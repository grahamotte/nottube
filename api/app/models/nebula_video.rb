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

class NebulaVideo < Video
  def execute_download
    vid = JSON.parse(
      RestClient.get(
        "https://player.zype.com/embed/#{remote_id}.json",
        params: {
          access_token: Setting.instance.nebula_tokens.dig('user', 'zype_auth_info', 'access_token'),
          download: true,
        }
      ).body
    )

    url = vid.dig('response', 'body', 'files').last.dig('url')
    type = vid.dig('response', 'body', 'files').last.dig('type')

    system(
      [
        'curl',
        "\"#{url}\"",
        '--output',
        "\"#{default_file_path(type)}\""
      ].join(' ')
    )
  end

  def refresh_metadata
    v = Zype::Videos.new.find(id: remote_id)

    update!(
      published_at: v.dig('published_at'),
      title: v.dig('title'),
      thumbnail_url: v.dig('thumbnails').last.dig('url'),
      description: v.dig('description'),
      duration: v.dig('duration'),
    )
  end
end
