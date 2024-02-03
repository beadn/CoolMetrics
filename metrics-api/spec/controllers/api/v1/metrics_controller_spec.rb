require 'rails_helper'

RSpec.describe Api::V1::MetricsController, type: :request do
  # Setup common test data
  let(:valid_attributes) { { name: 'cpu-usage', value: 50.0 } }
  let(:invalid_attributes) { { name: '', value: '' } }


  describe 'POST /api/v1/metrics' do
    context 'with valid attributes' do
      it 'creates a new metric' do
        expect {
          post '/api/v1/metrics', params: { metric: valid_attributes }
        }.to change(Metric, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new metric' do
        expect {
          post '/api/v1/metrics', params: { metric: invalid_attributes }
        }.to change(Metric, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end


