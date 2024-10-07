class AbsencesController < ApplicationController
  include AbsencesHelper

  # this constants are maybe not in the right file
  RENTAL_START_DATE = Date.new(2024, 1, 1)
  RENTAL_END_DATE = Date.new(2024, 12, 31)

  def index
    absences = Studio.includes(:stays).all.map { |studio| studio_absences(studio, RENTAL_START_DATE, RENTAL_END_DATE) }
    render json: absences
  end

  def create
    success = true

    feedback = create_params[:studios].map do |hash|
      call = UpdateAbsencesService.call(hash[:studio_id], hash[:absences])
      success & call.success?
      if call.success?
        studio_absences(call.result, RENTAL_START_DATE, RENTAL_END_DATE)
      else
        # TODO: tests this use case
        {
          studio_id: result.studio.id,
          errors: result.errors.full_messages.to_sentence
        }
      end
    end

    render json: feedback, status: success ? :created : :bad_request
  end

  private

  def create_params
    params.permit(
      studios: [
        :studio_id,
        { absences: %i[start_date end_date] }
      ]
    )
  end
end
