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

    absences = create_params[:studios].map do |hash|
      call = UpdateAbsencesService.call(hash[:studio_id], hash[:absences])
      success & call.success?
      # in case of failure, we may rollback any changes and return an error and switch to index hash
      # transaction should be around this loop
      studio_absences(call.result, RENTAL_START_DATE, RENTAL_END_DATE)
      # here we could grab service error and display them
    end

    render json: absences, status: success ? :created : :bad_request
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
