require 'rails_helper'

RSpec.describe AbsencesHelper do
  let(:studio) { create(:studio) }

  let!(:first_stay) do
    create(
      :stay,
      studio:,
      start_date: Date.new(2024, 9, 10),
      end_date: Date.new(2024, 9, 15)
    )
  end
  let!(:second_stay) do
    create(
      :stay,
      studio:,
      start_date: Date.new(2024, 9, 20),
      end_date: Date.new(2024, 9, 25)
    )
  end

  let(:start_date) { Date.new(2024, 9, 1) }

  subject(:absences) { studio_absences(studio, start_date, end_date).deep_symbolize_keys }

  describe '#studio_absences' do
    context 'when start_date is before first stay start_date' do
      let(:start_date) { Date.new(2024, 9, 1) }

      context 'when end_date is before second stay start_date' do
        let(:end_date) { Date.new(2024, 9, 17) }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: start_date.to_s, end_date: (first_stay.start_date - 1.day).to_s },
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: end_date.to_s }
            ]
          )
        end
      end

      context 'when end date is before second stay start_date' do
        let(:end_date) { Date.new(2024, 9, 17) }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: start_date.to_s, end_date: (first_stay.start_date - 1.day).to_s },
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: end_date.to_s }
            ]
          )
        end
      end

      context 'when end date is between second stay dates' do
        let(:end_date) { Date.new(2024, 9, 22) }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: start_date.to_s, end_date: (first_stay.start_date - 1.day).to_s },
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: (second_stay.start_date - 1.day).to_s }
            ]
          )
        end
      end

      context 'when end date is the day after second stay end_date' do
        let(:end_date) { Date.new(2024, 9, 26) }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: start_date.to_s, end_date: (first_stay.start_date - 1.day).to_s },
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: (second_stay.start_date - 1.day).to_s }
            ]
          )
        end
      end

      context 'when end date is after second stay end_date' do
        let(:end_date) { Date.new(2024, 9, 27) }

        it 'returns 3 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: start_date.to_s, end_date: (first_stay.start_date - 1.day).to_s },
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: (second_stay.start_date - 1.day).to_s },
              { start_date: (second_stay.end_date + 1.day).to_s, end_date: end_date.to_s }
            ]
          )
        end
      end
    end

    context 'when end date is after second stay end_date' do
      let(:end_date) { Date.new(2024, 9, 27) }

      context 'when start_date is equal to first stay start_date' do
        let(:start_date) { first_stay.start_date }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: (second_stay.start_date - 1.day).to_s },
              { start_date: (second_stay.end_date + 1.day).to_s, end_date: end_date.to_s }
            ]
          )
        end
      end

      context 'when start_date is inbetween first stay dates' do
        let(:start_date) { Date.new(2024, 9, 12) }

        it 'returns 2 absences' do
          expect(absences[:absences]).to eq(
            [
              { start_date: (first_stay.end_date + 1.day).to_s, end_date: (second_stay.start_date - 1.day).to_s },
              { start_date: (second_stay.end_date + 1.day).to_s, end_date: end_date.to_s }
            ]
          )
        end
      end
    end
  end
end
