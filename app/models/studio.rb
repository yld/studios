class Studio < ApplicationRecord
  has_many :stays, -> { order("start_date ASC") }, dependent: :destroy

  def next_stay(start_date)
    stays.stays
  end
end
