# == Schema Information
#
# Table name: settings
#
#  id           :integer          not null, primary key
#  yt_api_key   :string
#  videos_path  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  nebula_user  :string
#  nebula_pass  :string
#  nebula_cache :text
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
  validates :yt_api_key, presence: true, unless: -> { yt_api_key.presence.nil? }
  validate :validate_yt_api_key, unless: -> { yt_api_key.blank? }
  def validate_yt_api_key
    Yt.configure { |c| c.api_key = yt_api_key }
    Yt::Collections::Videos.new.first
  rescue Yt::Errors::RequestError
    errors.add(:base, 'youtube API key is not valid')
  end

  # Nebula
  validates :nebula_user, presence: true, unless: -> { nebula_user.presence.nil? && nebula_pass.presence.nil? }
  validates :nebula_pass, presence: true, unless: -> { nebula_user.presence.nil? && nebula_pass.presence.nil? }
  validate :validate_nebula_creds, unless: -> { nebula_user.blank? && nebula_pass.blank? }
  def get_nebula_cache_json
    @get_nebula_cache_json ||= begin
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

      {
        login: login,
        user: user,
        public: public_info,
      }.to_json
    end
  end

  def reset_nebula_cache
    update!(nebula_cache: get_nebula_cache_json)
  end

  def validate_nebula_creds
    self.nebula_cache = get_nebula_cache_json
    save!(validate: false)
  rescue Zype::Client::Unauthorized
    errors.add(:base, 'nebula API key is not valid')
  end
end
