module AbsencesHelper
  # return an array of hashes
  # each hash conaining a studio id and an absences hash of dates (start_date and end_date)
  # each date is dumped in the standard english parseable format %y-%m-%d
  def studio_absences(studio, start_date, end_date)
    # start_date = start_date.to_date unless start_date.is_a?(Date)
    # end_date = end_date.to_date unless end_date.is_a?(Date)

    absences = []
    studio.stays.where("start_date < ?", end_date).each do |stay|
      absences << { start_date: start_date.to_s, end_date: (stay.start_date - 1.day).to_s } if stay.start_date > start_date
      start_date = (stay.end_date + 1.day).to_date
    end
    absences << { start_date: start_date.to_s, end_date: end_date.to_s } unless start_date >= end_date
    { studio_id: studio.id, absences: }
  end
end
