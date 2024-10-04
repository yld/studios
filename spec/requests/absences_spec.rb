require 'rails_helper'

RSpec.describe "Absences", type: :request do
  describe "GET /absences" do
    let(:studio) { create(:studio) }
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

    it "returns http success" do
      get "/absences", as: :json
      require 'pry'; binding.pry
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(
        [
          {
            "studio_id": studio.id,
            "absences": [
              {
                "start_date": AbsencesController::RENTAL_START_DATE.to_date.to_s,
                "end_date": first_stay.start_date.to_date.to_s ,
              },
              {
                "start_date": first_stay.end_date.to_date.to_s ,
                "end_date": second_stay.start_date.to_date.to_s ,
              },
              {
                "start_date": second_stay.end_date.to_date.to_s ,
                "end_date": AbsencesController::RENTAL_END_DATE.to_date.to_s
              }
            ]
          }
        ]
      )
    end
  end

  describe "POST /absences" do
    it "returns http success" do
      post "/absences", as: :json
      expect(response).to have_http_status(:created)
    end
  end
end
