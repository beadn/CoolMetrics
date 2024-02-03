require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::MetricsController, type: :request do
  # Setup common test data
  let(:valid_attributes) { { name: 'cpu-usage', value: 50.0 } }
  let(:invalid_attributes) { { name: '', value: '' } }

  let!(:metrics) { create_list(:metric, 10, name: 'cpu-usage', value: rand(1..100)) }
  let!(:specific_metrics) { create_list(:metric, 5, name: 'disk-usage', value: rand(1..100)) }

  describe 'GET /api/v1/metrics' do
    context 'without any parameters' do
      before { get '/api/v1/metrics' }

      it 'returns all metrics' do
        expect(JSON.parse(response.body)['data'].size).to eq(15)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a name parameter' do
      before { get '/api/v1/metrics', params: { name: 'disk-usage' } }

      it 'returns metrics filtered by name' do
        expect(JSON.parse(response.body)['data'].size).to eq(5)
        JSON.parse(response.body)['data'].each do |metric|
          expect(metric['attributes']['name']).to eq('disk-usage')
        end
        expect(response).to have_http_status(:ok)
      end
    end
  end

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


