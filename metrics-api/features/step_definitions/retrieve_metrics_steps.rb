# Using FactoryBot to create existing metrics

Given('there are existing metrics') do
end

When('I request all metrics') do
  @response = get "/api/v1/metrics"
end

Then('I should see all the metrics') do
  metrics = JSON.parse(@response.body)
  expect(metrics['data'].count).to eq(Metric.all.count) 
end

Given('there are existing metrics with name {string}') do |name|
  FactoryBot.create_list(:metric, 5, name: name)
end

When('I request all metrics with name {string}') do |name|
  @response = get "/api/v1/metrics?name=#{name}"
end

Then('I should see all the metrics named {string}') do |name|
  returned_metrics = JSON.parse(@response.body)
  all_named_correctly = returned_metrics['data'].all? do |metric|
    metric_data = metric['attributes']
    metric_data['name'] == name
  end
  expect(all_named_correctly).to be true
end
