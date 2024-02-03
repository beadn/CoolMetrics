Given('I am an API consumer') do
   end
  
   When('I submit a new metric with name {string} and value {float}') do |name, value|
    @response = RestClient.post(
      'http://localhost:3000/api/v1/metrics',
      { metric: { name: name, value: value } }.to_json,
      { content_type: :json, accept: :json }
    )
  end
  
  Then('the metric should be saved and the response should include name {string} and value {float}') do |name, value|
    expect(@response.code).to eq 201
    json_response = JSON.parse(@response.body)
    expect(json_response.dig('data', 'attributes', 'name')).to eq name
    expect(json_response.dig('data', 'attributes', 'value').to_f).to eq value
  end
  