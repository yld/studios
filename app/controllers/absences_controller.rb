class AbsencesController < ApplicationController
  # this constants are maybe not in the right file
  RENTAL_START_DATE = Date.new(2024, 1, 1)
  RENTAL_END_DATE = Date.new(2024, 12, 31)

  def index
    absences = all_studios.map { |studio| studio_absences(studio) }
    render json: absences
  end

  def create
  end

  private

  def all_studios
    @all_studios = Studio.includes(:stays).all
  end

  def studio_absences(studio, start_date = RENTAL_START_DATE, end_date = RENTAL_END_DATE)
    absences = []
    studio.stays.where("start_date < ?", RENTAL_END_DATE).each do |stay|
      absences << { start_date: start_date, end_date: stay.start_date } if stay.start_date > start_date
      start_date = stay.end_date
    end
    absences << { start_date: start_date, end_date:  }
    { studio_id: studio.id, absences: }
  end
end
