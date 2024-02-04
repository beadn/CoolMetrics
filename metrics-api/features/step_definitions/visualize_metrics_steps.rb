# Use a Before hook for setting up existing metrics
Before do
  ['cpu-load', 'memory-usage'].each do |metric_name|
    FactoryBot.create_list(:metric, 100, name: metric_name, timestamp: 30.days.ago..Time.now, value: rand(25.0..75.0).round(2))
  end
end


When('I request all metrics to be aggregated by {string}') do |time_frame|
  @response = get "/api/v1/metrics?time_frame=#{time_frame}"
  @json_response = JSON.parse(@response.body)
end

Then('I should see all the metrics aggregated by {string}') do |time_frame|
  expect(@response.status).to eq(200)
  expect(@json_response['data']).not_to be_empty

end


When('I request all metrics for {string} to be aggregated by {string}') do |name, time_frame|
  @response = get "/api/v1/metrics?name=#{name}&time_frame=#{time_frame}"
  @json_response = JSON.parse(@response.body)
end


Then('the aggregation should include only {string} metrics') do |name|
  # Check if there are any metrics in the response
  expect(@json_response['data']).not_to be_empty, "No metrics found in the aggregation"
  puts @json_response['data']

  # Check if all metrics in the response have the expected name
  @json_response['data'].each do |metric|
    expect(metric['attributes']['name']).to eq(name), "Expected metric name to be '#{name}', but found '#{metric['attributes']['name']}'"
  end
end