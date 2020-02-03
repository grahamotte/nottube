class SettingsController < ApplicationController
  def index
    render json: Setting.instance.attributes
  end

  def update
    s = Setting.instance
    s.assign_attributes(params.permit(:yt_api_key, :videos_path, :nebula_api_key))

    if s.valid?
      s.save!
      head :ok
    else
      render json: { error: s.errors.full_messages.to_sentence }
    end
  end
end
