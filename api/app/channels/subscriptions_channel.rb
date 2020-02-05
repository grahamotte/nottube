class SubscriptionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'subscriptions'
  end
end
