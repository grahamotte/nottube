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

  # videos
  validates :videos_path, presence: true
  validate :validate_videos_path_presence

  def validate_videos_path_presence
    return unless videos_path.present?
    return if Dir.exists?(videos_path)
    errors.add(:base, 'videos directory does not exist')
  end

  # Yt
  def yt_api_keys
    [yt_api_key_a, yt_api_key_b, yt_api_key_c].compact
  end

  ['a', 'b', 'c'].each do |pos|
    eval <<-RUBY
      validates :yt_api_key_#{pos}, presence: true, unless: -> { yt_api_key_#{pos}.blank? }
      validate :validate_yt_api_key_#{pos}, unless: -> { yt_api_key_#{pos}.blank? }
      def validate_yt_api_key_#{pos}
        Yt.configure { |c| c.api_key = yt_api_key_#{pos} }
        Yt::Collections::Videos.new.first
      rescue StandardError
        errors.add(:base, 'Youtube #{pos} API key is not valid')
      end
    RUBY
  end

  # validates :yt_api_key, presence: true, unless: -> { yt_api_key.blank? }
  # validate :validate_yt_api_key, unless: -> { yt_api_key.blank? }
  # def validate_yt_api_key
  #   Yt.configure { |c| c.api_key = yt_api_key }
  #   Yt::Collections::Videos.new.first
  # rescue StandardError
  #   errors.add(:base, 'youtube API key is not valid')
  # end

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
  rescue StandardError => e
    errors.add(:base, 'nebula API key is not valid')
  end
end
