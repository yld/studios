# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

first_studio = Studio.create!(
  opening: Date.new(2024, 1, 1)
)
second_studio = Studio.create!(
  opening: Date.new(2024, 1, 1)
)

Stay.create!(
  studio: first_studio,
  start_date: Date.new(2024, 1, 1),
  end_date: Date.new(2024, 1, 8)
)
Stay.create!(
  studio: first_studio,
  start_date: Date.new(2024, 1, 16),
  end_date: Date.new(2024, 1, 24)
)

Stay.create!(
  studio: second_studio,
  start_date: Date.new(2024, 1, 5),
  end_date: Date.new(2024, 1, 10)
)
Stay.create!(
  studio: second_studio,
  start_date: Date.new(2024, 1, 15),
  end_date: Date.new(2024, 1, 20)
)
Stay.create!(
  studio: second_studio,
  start_date: Date.new(2024, 1, 21),
  end_date: Date.new(2024, 1, 25)
)
