Given('I am an API consumer') do
end
  
   When('I submit a new metric with name {string} and value {float}') do |name, value|
    @response = RestClient.post(
      'http://localhost:3000/api/v1/metrics',
      { metric: { name: name, value: value } }.to_json,
      { content_type: :json, accept: :json }
    )
  end
  
  Then('the response should include name {string}, value {float} and an id' ) do |name, value|
    expect(@response.code).to eq 201
    json_response = JSON.parse(@response.body)
    expect(json_response.dig('data', 'id').to_i).to be_an(Integer) 
    expect(json_response.dig('data', 'attributes', 'name')).to eq name
    expect(json_response.dig('data', 'attributes', 'value').to_f).to eq value
  end
  
  When('I submit a new metric with name {string}, value {float}, and timestamp {string}') do |name, value, timestamp|
    begin
      @response = RestClient.post(
        'http://localhost:3000/api/v1/metrics',
        { metric: { name: name, value: value, timestamp: timestamp } }.to_json,
        { content_type: :json, accept: :json }
    )
    rescue RestClient::ExceptionWithResponse => e
      @response = e.response
    end 
  end

  Then('the response should include name {string}, value {float}, and timestamp {string}' ) do |name, value, timestamp|
    expect(@response.code).to eq 201
    json_response = JSON.parse(@response.body)
    expect(json_response.dig('data', 'attributes', 'name')).to eq name
    expect(json_response.dig('data', 'attributes', 'value').to_f).to eq value
    expect(json_response.dig('data', 'attributes', 'timestamp')).to eq timestamp
  end

  
  When('I submit a new metric with no name, value {float}') do |value|
    begin
      @response = RestClient.post(
        'http://localhost:3000/api/v1/metrics',
        { metric: { value: value } }.to_json, # Remove the 'name' field from the request
        { content_type: :json, accept: :json }
      )
    rescue RestClient::ExceptionWithResponse => e
      @response = e.response
    end
  end

  Then('the response should indicate a validation error for missing name') do
    expect(@response.code).to eq 422
    json_response = JSON.parse(@response.body)
    expect(json_response['error']).to include('name')
  end
  
  When('I submit a new metric with name {string} and an invalid value') do |name|
    begin
      @response = RestClient.post(
        'http://localhost:3000/api/v1/metrics',
        { metric: { name: name, value: "invalid" } }.to_json,
        { content_type: :json, accept: :json }
     )
    rescue RestClient::ExceptionWithResponse => e
      @response = e.response
     end 
  end
  
  Then('the response should indicate a validation error for the value') do
    expect(@response.code).to eq 422
    json_response = JSON.parse(@response.body)
    expect(json_response['error']).to include('value')
  end
  
