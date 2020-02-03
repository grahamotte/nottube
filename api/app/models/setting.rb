# == Schema Information
#
# Table name: settings
#
#  id             :integer          not null, primary key
#  yt_api_key     :string
#  videos_path    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  nebula_api_key :string
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
  validates :nebula_api_key, presence: true, unless: -> { nebula_api_key.presence.nil? }
  validate :validate_nebula_api_key, unless: -> { nebula_api_key.blank? }
  def validate_nebula_api_key
    Zype.configure { |c| c.api_key = nebula_api_key }
    Zype::Videos.new.all
  rescue Zype::Client::Unauthorized
    errors.add(:base, 'nebula API key is not valid')
  end
end
