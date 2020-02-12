# == Schema Information
#
# Table name: settings
#
#  id           :integer          not null, primary key
#  yt_api_key_a :string
#  videos_path  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  nebula_user  :string
#  nebula_pass  :string
#  nebula_cache :text
#  yt_api_key_b :string
#  yt_api_key_c :string
#

class Setting < ApplicationRecord
  def self.instance
    first_or_create
  end

  # Nebula
  validates :nebula_user, presence: true, unless: -> { nebula_user.blank? && nebula_pass.blank? }
  validates :nebula_pass, presence: true, unless: -> { nebula_user.blank? && nebula_pass.blank? }
  validate :validate_nebula_creds, unless: -> { nebula_user.blank? && nebula_pass.blank? }

  def nebula_tokens
    parsed_cache = JSON.parse(Setting.instance.nebula_cache.presence || '{}')
    ttl = parsed_cache.dig('user', 'zype_auth_info', 'expires_at')

    return parsed_cache if ttl.present? && Time.now < Time.at(ttl)

    login = JSON.parse(RestClient.post(
        'https://api.watchnebula.com/api/v1/auth/login/',
        { email: nebula_user, password: nebula_pass }.to_json,
        headers: {
          Origin: 'https://watchnebula.com',
          Host: 'api.watchnebula.com',
          Referer: 'https://watchnebula.com/login',
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:72.0) Gecko/20100101 Firefox/72.0',
          Pragma: 'no-cache',
        },
        content_type: :json,
        accept: :json,
      ).body
    )
    user = JSON.parse(
      RestClient.get(
        'https://api.watchnebula.com/api/v1/auth/user/',
        Authorization: "Token #{login.dig('key')}",
      ).body
    )
    public_info = Nokogiri(RestClient.get('https://watchnebula.com/').body)
      .css('script')
      .find { |x| x.text.include?('ZYPE_API_KEY') }
      .then { |x| x.text.gsub(';', '').gsub('window.env = ', '') }
      .then { |x| JSON.parse(x) }

    update_attribute(
      'nebula_cache',
      { login: login, user: user, public: public_info }.to_json,
    )

    JSON.parse(nebula_cache)
  end

  def validate_nebula_creds
    raise unless nebula_tokens.fetch('public').fetch('ZYPE_API_KEY').present?
    raise unless nebula_tokens.fetch('user').fetch('zype_auth_info').fetch('access_token').present?
  # rescue StandardError => e
  #   errors.add(:base, 'nebula API key is not valid')
  end
end
