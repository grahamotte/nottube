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

class NebulaSubscription < Subscription
  def configure_for_me
    Zype.configure { |c| c.api_key = key || Setting.instance.nebula_api_key }
  end

  def remote_videos
  end

  def refresh_metadata
  end
end
