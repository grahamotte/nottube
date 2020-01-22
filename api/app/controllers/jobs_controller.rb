class JobsController < ApplicationController
  def index
    jobs = Delayed::Job.all.sort_by(&:created_at).reverse.map do |j|
      {
        class: j.payload_object.job_data.dig("job_class"),
        arguments: j.payload_object.job_data.dig("arguments").to_s,
        attempts: j.attempts,
        error: j.last_error&.split("\n")&.first,
        created_at: j.created_at,
        running: j.locked_at.present?,
      }
    end

    render json: jobs
  end
end
