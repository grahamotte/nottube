class JobsController < ApplicationController
  def index
    jobs = Delayed::Job.all.sort_by(&:created_at).map do |j|
      {
        class: j.payload_object.job_data.dig("job_class"),
        arguments: j.payload_object.job_data.dig("arguments").join(", "),
        attempts: j.attempts,
        error: j.last_error,
        created_at: j.created_at,
        running: j.locked_at.present?,
      }
    end

    render json: jobs
  end

  def destroy_all
    Delayed::Job.all.each { |j| j.destroy! }

    head :ok
  end
end
