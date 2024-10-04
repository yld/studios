require 'rails_helper'

RSpec.describe Studio, type: :model do
  let(:studio) { create(:studio) }

  describe '#stays' do
    context 'whith several stays' do
      let!(:first_stay) do
        create(
          :stay,
          studio:,
          start_date: 7.days.ago,
          end_date: 6.days.ago
        )
      end
      let!(:second_stay) do
        create(
          :stay,
          studio:,
          start_date: 4.days.ago,
          end_date: 3.days.ago
        )
      end

      it 'returns ordered stays' do
        expect(studio.stays.first.start_date).to eq(first_stay.start_date)
      end
    end
  end
end
