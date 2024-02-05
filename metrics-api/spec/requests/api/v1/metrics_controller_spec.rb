require 'rails_helper'

RSpec.describe Api::V1::MetricsController, type: :request do
  let!(:metrics) { create_list(:metric, 10, name: 'cpu-usage', value: rand(1..100), timestamp: Time.zone.now) }

  describe 'GET /api/v1/metrics' do
    context 'without any parameters' do
      before { get '/api/v1/metrics' }

      it 'returns all metrics' do
        json_response = JSON.parse(response.body)
        expect(json_response['data'].size).to eq(10)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a name parameter' do
      before { get '/api/v1/metrics', params: { name: 'disk-usage' } }

      it 'returns metrics filtered by name' do
        json_response = JSON.parse(response.body)
        expect(json_response['data'].size).to eq(0)
        expect(response).to have_http_status(:ok)
      end
    end

    ['minute', 'hour', 'day'].each do |time_frame|
      context "with a time_frame parameter set to #{time_frame}" do
        before { get '/api/v1/metrics', params: { time_frame: time_frame } }

        it "aggregates metrics by #{time_frame}" do
          json_response = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end

  describe 'GET /api/v1/metrics with time_frame aggregation' do
    let!(:day1_metrics) do
      3.times.map do |i|
        create(:metric, name: 'cpu-usage', value: (10 + i), timestamp: 2.days.ago.beginning_of_day + i.hours)
      end
    end

    let!(:day2_metrics) do
      2.times.map do |i|
        create(:metric, name: 'cpu-usage', value: (20 + i), timestamp: 1.day.ago.beginning_of_day + i.hours)
      end
    end

    context 'aggregated by day' do
      before { get '/api/v1/metrics', params: { time_frame: 'day' } }
    
      it 'returns correctly aggregated metrics' do
        json_response = JSON.parse(response.body)
    
        expect(response).to have_http_status(:ok)
        expect(json_response['data']).not_to be_empty
    
        # Expect 3 aggregated metrics (one for each day)
        expect(json_response['data'].size).to eq(3)
    
        # Calculate average values for day1_metrics and day2_metrics
        day1_average_value = day1_metrics.sum(&:value) / day1_metrics.size.to_f
        day2_average_value = day2_metrics.sum(&:value) / day2_metrics.size.to_f
    
        # Check if aggregated metrics' values are within a small margin (0.01) of the calculated averages
        expect(json_response['data'][0]['attributes']['value'].to_f).to be_within(0.01).of(day1_average_value)
        expect(json_response['data'][1]['attributes']['value'].to_f).to be_within(0.01).of(day2_average_value)


      end
    end
  end

  describe 'POST /api/v1/metrics' do
    let(:valid_attributes) { { name: 'cpu-usage', value: 50.0, timestamp: Time.now } }
    let(:invalid_attributes) { { name: '', value: '', timestamp: '' } }

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
