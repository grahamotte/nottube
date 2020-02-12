# == Schema Information
#
# Table name: subscriptions
#
#  id               :bigint           not null, primary key
#  remote_id        :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string           default("YtSubscription")
#

class NebulaSubscription < Subscription
  def configure_for_me
    Zype.configuration.api_key = Setting.instance.nebula_tokens.dig('public', 'ZYPE_API_KEY')
  end

  def friendly_name
    'Nebula'
  end

  def video_class
    NebulaVideo
  end

  def refresh_metadata
    ias = JSON.parse(
      Nokogiri::HTML(
        RestClient.get('https://watchnebula.com').body
      ).at_css('#initial-app-state').text
    )

    sub_name = url.split('/').last.gsub('/', '')
    nebula_id = ias.dig('channels', 'byURL', sub_name)
    remote_detail = ias.dig('channels', 'byID', nebula_id)
    remote_id = remote_detail.dig('playlist_id')
    z_playlist = Zype::Playlists.new.find(id: remote_id)

    update!(
      remote_id: remote_id,
      title: remote_detail.dig('title'),
      thumbnail_url: remote_detail.dig('avatar'),
      description: remote_detail.dig('bio'),
      video_count: z_playlist.dig('playlist_item_count'),
    )
  end

  def remote_video_ids(n)
    params = {
      "playlist_id.inclusive" => remote_id,
      api_key: Setting.instance.nebula_tokens.dig('public', 'ZYPE_API_KEY'),
      per_page: 100,
      sort: 'published_at',
      order: 'desc'
    }

    RestClient.get('https://api.zype.com/videos', params: params)
      .then { |x| JSON.parse(x.body) }
      .dig('response')
      .map { |v| v.dig('_id') }
      .first(n)
  end
end
