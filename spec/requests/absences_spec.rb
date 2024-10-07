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

    let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }
    it "returns http success" do
      get "/absences", as: :json
      expect(response).to have_http_status(:success)
      # expect(parsed_response).to eq(
      #   [
      #     {
      #       "studio_id": studio.id,
      #       "absences": [
      #         {
      #           "start_date": AbsencesController::RENTAL_START_DATE.to_date.to_s,
      #           "end_date": (first_stay.start_date + 1.day).to_date.to_s
      #         },
      #         {
      #           "start_date": first_stay.end_date.to_date.to_s,
      #           "end_date": (second_stay.start_date + 1.day).to_date.to_s
      #         },
      #         {
      #           "start_date": second_stay.end_date.to_date.to_s,
      #           "end_date": AbsencesController::RENTAL_END_DATE.to_date.to_s
      #         }
      #       ]
      #     }
      #   ]
      # )
    end
  end

  describe "POST /absences" do
    let(:first_studio) { create(:studio) }

    let(:payload) do
      {
        studios: [
          {
            studio_id: first_studio.id,
            absences: [
              {
                start_date: Date.yesterday,
                end_date: Date.today
              }
            ]
          }
        ]
      }
    end

    it "returns http success" do
      post "/absences", as: :json, params: payload
      expect(response).to have_http_status(:created)
    end
  end
end
