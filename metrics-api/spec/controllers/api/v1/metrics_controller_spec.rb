require 'rails_helper'

RSpec.describe Api::V1::MetricsController, type: :request do
 
  describe 'GET /api/v1/metrics' do

  let!(:metrics) { create_list(:metric, 10, name: 'cpu-usage', value: rand(1..100), timestamp: Time.zone.now) }
  let!(:specific_metrics) { create_list(:metric, 5, name: 'disk-usage', value: rand(1..100), timestamp: Time.zone.now) }

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

    # New contexts for testing aggregation by time_frame
    ['minute', 'hour', 'day'].each do |time_frame|
      context "with a time_frame parameter set to #{time_frame}" do
        before { get '/api/v1/metrics', params: { time_frame: time_frame } }

        it "aggregates metrics by #{time_frame}" do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).not_to be_empty

        end
      end
    end
  end


  describe 'GET /api/v1/metrics with time_frame aggregation' do
    # Prepares test data by creating metrics for two distinct days to test the aggregation functionality.
    # This setup aims to have metrics that can be aggregated by day to verify the correct operation of the aggregation logic.
    let!(:day1_metrics) {
      # Creates 3 metrics for 'cpu-usage' with increasing values, all timestamped to 2 days ago but at different hours.
      3.times.map do |i|
        create(:metric, name: 'cpu-usage', value: (10 + i), timestamp: 2.days.ago.beginning_of_day + i.hours)
      end
    }
  
    let!(:day2_metrics) {
      # Creates 2 metrics for 'cpu-usage' with increasing values, all timestamped to 1 day ago but at different hours.
      2.times.map do |i|
        create(:metric, name: 'cpu-usage', value: (20 + i), timestamp: 1.day.ago.beginning_of_day + i.hours)
      end
    }
  
    context 'aggregated by day' do
      # Executes a GET request to the metrics endpoint with the 'day' time frame parameter before each test.
      before { get '/api/v1/metrics', params: { time_frame: 'day' } }
  
      it 'returns correctly aggregated metrics' do
        # Parses the JSON response body to facilitate access to its data.
        json_response = JSON.parse(response.body)
  
        # Asserts that the response status is OK (200) and that the data array is not empty,
        # indicating that metrics were successfully retrieved and aggregated.
        expect(response).to have_http_status(:ok)
        expect(json_response['data']).not_to be_empty
  
        # Asserts that exactly 2 aggregated metric records are returned, one for each day.
        expect(json_response['data'].size).to eq(2)
  
        # Calculates the average value of metrics for each day to use as the expected value in assertions.
        day1_average_value = day1_metrics.sum(&:value) / day1_metrics.size.to_f
        day2_average_value = day2_metrics.sum(&:value) / day2_metrics.size.to_f
  
        # Converts the 'value' attribute of the first and last metric in the response to floating-point numbers
        # for accurate comparison with the calculated average values.
        first_metric_value = json_response['data'].first['attributes']['value'].to_f
        last_metric_value = json_response['data'].last['attributes']['value'].to_f
  
        # Asserts that the first metric's value is within a small margin (0.01) of the expected average value for day 1,
        # and similarly for the last metric and day 2, ensuring the aggregation logic is functioning as expected.
        expect(first_metric_value).to be_within(0.01).of(day1_average_value)
        expect(last_metric_value).to be_within(0.01).of(day2_average_value)
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
