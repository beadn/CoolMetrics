Given('there are existing metrics') do
    @existing_metric = { name: 'existing-metric', value: 50 }
    RestClient.post('http://localhost:3000/api/v1/metrics',
                    { metric: @existing_metric }.to_json,
                    { content_type: :json, accept: :json })
  end
  
  When('I request all metrics') do
    @response = RestClient.get('http://localhost:3000/api/v1/metrics', { accept: :json })
  end

  Then('I should see all the metrics') do
    metrics = JSON.parse(@response.body)
  found = metrics['data'].any? do |metric|
    metric_data = metric['attributes']
    metric_data['name'] == @existing_metric[:name] && metric_data['value'].to_i == @existing_metric[:value]
  end
  expect(found).to be true
  end
  

  Given('there are existing metrics with name {string}') do |name|
    @existing_metric = { name: name, value: 50 }
    RestClient.post('http://localhost:3000/api/v1/metrics',
                    { metric: @existing_metric }.to_json,
                    { content_type: :json, accept: :json })
  end

  When('I request all metrics with name {string}') do |name|
    @response = RestClient.get("http://localhost:3000/api/v1/metrics?name=#{name}", { accept: :json })
  end
  
  Then('I should see all the metrics named {string}') do |name|
    returned_metrics = JSON.parse(@response.body)
    all_named_correctly = returned_metrics['data'].all? do |metric|
      metric_data = metric['attributes']
      metric_data['name'] == name
    end
    expect(all_named_correctly).to be true
  end
  
 