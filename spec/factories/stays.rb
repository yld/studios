FactoryBot.define do
  factory :stay do
    studio
    start_date { 3.days.ago }
    end_date { 2.days.ago }
  end
end
