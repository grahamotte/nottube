# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  remote_id        :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  keep_count       :integer          default(8), not null
#  type             :string
#

class Subscription < ApplicationRecord
  has_many :videos

  def videos_to_keep
    videos.first(keep_count)
  end

  def refresh_metadata
    raise 'implement me'
  end

  def remote_videos
    raise 'implement me'
  end

  def configure_for_me
    raise 'implement me'
  end
end
