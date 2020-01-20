class DownloadEnqueueJob < ApplicationJob
  def perform
    Subscription.all.each do |sub|

    end
  end
end
