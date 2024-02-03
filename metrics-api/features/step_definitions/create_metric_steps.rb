Given('I am an API consumer') do
   end
  
   When('I submit a new metric with name {string} and value {int}') do |name, value|
    @response = RestClient.post('http://localhost:3000/api/v1/metrics',
                                { metric: { name: name, value: value } }.to_json,
                                { content_type: :json, accept: :json })
    @created_metric_id = JSON.parse(@response.body)['id']
  end
  
  Then('the metric should be saved in the system') do
    expect(@response.code).to eq 201
  end
  