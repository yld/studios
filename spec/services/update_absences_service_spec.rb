require 'rails_helper'

RSpec.describe UpdateAbsencesService do
  let(:studio) { create(:studio) }

  let!(:first_stay) do
    create(
      :stay,
      studio:,
      start_date: Date.new(2024, 8, 29),
      end_date: Date.new(2024, 9, 5)
    )
  end
  let!(:second_stay) do
    create(
      :stay,
      studio:,
      start_date: Date.new(2024, 9, 10),
      end_date: Date.new(2024, 9, 15)
    )
  end

  let!(:third_stay) do
    create(
      :stay,
      studio:,
      start_date: Date.new(2024, 9, 25),
      end_date: Date.new(2024, 10, 3)
    )
  end


  let(:start_date) { Date.new(2024, 9, 1) }
  let(:end_date) { Date.new(2024, 9, 30) }

  let(:absence_start_date) { Date.new(2024, 8, 27) }
  let(:absence_end_date) { Date.new(2024, 10, 3) }

  let(:absences) do
    [
      {
        start_date: absence_start_date,
        end_date: Date.new(2024, 9, 7)
      },
     {
        start_date: Date.new(2024, 9, 13),
        end_date: Date.new(2024, 9, 17)
      },
      {
        start_date: Date.new(2024, 9, 27),
        end_date: absence_end_date
      }
    ]
  end

  subject(:call) { described_class.call(studio.id, absences) }

  # shared_examples 'a success' do
  #   it { expect(call).to be_succcess }
  # end

  describe '#call' do
    context 'when an absence outreachs start_date' do
      it 'removes first stay' do
        expect(call.success?).to be_truthy # something buggy here, be_success matcher does not want to work
        expect(studio.stays.count).to eq(2)
      end
    end

    context 'when no absence outreachs start_date' do
      let(:absence_start_date) { Date.new(2024, 8, 30) }

      it 'keeps all stays' do
        expect(call.success?).to be_truthy # something buggy here, be_success matcher does not want to work
        expect(studio.stays.count).to eq(3)
      end
    end

    context 'when an absence outreachs end_date' do
      let(:absence_end_date) { Date.new(2024, 10, 5) }

      it 'removes third stay' do
        expect(call.success?).to be_truthy # something buggy here, be_success matcher does not want to work
        expect(studio.stays.count).to eq(2)
      end
    end

    context 'when an absence is inside a stay' do
      let(:absences) do
        [
          {
            start_date: Date.new(2024, 9, 11),
            end_date: Date.new(2024, 9, 13)
          }
        ]
      end

      it 'splits second stay' do
        expect(call.success?).to be_truthy # something buggy here, be_success matcher does not want to work
        expect(studio.stays.count).to eq(4)
      end
    end
  end
end
