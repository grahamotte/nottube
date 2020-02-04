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
    # JSON.parse(
    #   RestClient.get(
    #     'https://player.zype.com/embed/5e33f8661c998a003.json',
    #     params: {
    #       access_token: '6da7f88217459ec312f7450f9a26c6d89b2751d7d84b9d5cf1105',
    #       download: true,
    #     }
    #   ).body
    # )
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
