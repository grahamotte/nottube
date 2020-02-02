class ApplicationJob < ActiveJob::Base
  before_perform do
    Setting.configure_yt
  end
end
