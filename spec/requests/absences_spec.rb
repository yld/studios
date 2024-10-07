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
      # TODO: add one more expectatin verifying expected method was called with expected agument (or something else...)
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
    before do
      allow(UpdateAbsencesService).to receive(:call).and_call_original
    end

    it "returns http success" do
      post "/absences", as: :json, params: payload
      expect(response).to have_http_status(:created)
      expect(UpdateAbsencesService).to have_received(:call)  # TODO: specify arguments
    end
  end
end
