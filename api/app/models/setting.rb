# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  yt_api_key  :string
#  videos_path :string
#

class Setting < ApplicationRecord
  before_validation :configure_yt

  validates :yt_api_key, presence: true
  validates :videos_path, presence: true

  validate :validate_yt_api_key
  validate :validate_videos_path_presence

  def self.configure_yt
    instance.configure_yt
  end

  def configure_yt
    return if yt_api_key.blank?
    Yt.configure { |c| c.api_key = yt_api_key }
  end

  def validate_yt_api_key
    return if yt_api_key.blank?
    Yt::Collections::Videos.new.first
  rescue Yt::Errors::RequestError
    errors.add(:base, 'youtube API key is not valid')
  end

  def validate_videos_path_presence
    return unless videos_path.present?
    return if Dir.exists?(videos_path)

    errors.add(:base, 'videos directory does not exist')
  end

  def self.instance
    first_or_create
  end
end
