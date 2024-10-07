class UpdateAbsencesService
  prepend SimpleCommand

  def initialize(studio_id, absences)
    @studio_id = studio_id
    @absences = absences
  end

  def call
    begin
      @studio = Studio.includes(:stays).find(@studio_id)
    rescue ActiveRecord::RecordNotFound => exception
      error.add(:base, exception.message)
    end

    return if failure?

    update_absences
    @studio # our result
  end

  private

  def clear_included_stays(hash)
    @studio.stays.where(
        "start_date > ? AND end_date < ?", hash[:start_date], hash[:end_date]
    ).delete_all
  end

  def split_overlapping_stay(hash)
    first_stay = @studio.stays.where(
        "start_date < ? AND end_date > ?", hash[:start_date], hash[:end_date]
    ).first
    return unless first_stay

    second_stay = first_stay.dup

    first_stay.update(end_date: hash[:start_date])
    second_stay.update(start_date: hash[:end_date])
  end

  def shrink_stay_start(hash)
    @studio.stays.where(
      "start_date > ? AND start_date < ?", hash[:start_date], hash[:end_date]
    )&.update(
      start_date: hash[:end_date]
    )
  end

  def shrink_stay_end(hash)
    @studio.stays.where(
      "end_date > ? AND end_date < ?", hash[:start_date], hash[:end_date]
    )&.update(
      end_date: hash[:start_date]
    )
  end

  def update_absences
    ActiveRecord::Base.transaction do
      @absences.each do |hash|
        # here we embrace the 4 use cases with a slow algo
        clear_included_stays(hash)
        split_overlapping_stay(hash)
        shrink_stay_start(hash)
        shrink_stay_end(hash)
      end

      # not necessary to test it there
      # rescue StandardError => exception
      #   errors.add(:base, exception.message)
      #   raise ActiveRecord::Rollback
    end
  end
end
