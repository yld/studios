class Studio < ApplicationRecord
  has_many :stays, -> { order("start_date ASC") }, dependent: :destroy
end
