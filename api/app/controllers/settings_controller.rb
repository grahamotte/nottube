class SettingsController < ApplicationController
  def index
    render json: Setting.instance.attributes
  end

  def update
    update_params = params.permit(
      :nebula_pass,
      :nebula_user,
      :keep_count,
      :look_back_count,
    )

    s = Setting.instance
    s.assign_attributes(update_params)

    if s.valid?
      s.save!
      head :ok
    else
      render json: { error: s.errors.full_messages.to_sentence }
    end
  end
end
