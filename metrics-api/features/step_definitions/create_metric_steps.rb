  Given('I am an API consumer') do
  end
    
  When('I submit a new metric with name {string} and value {float}') do |name, value|
    @response = post "/api/v1/metrics", { metric: { name: name, value: value } }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end
  
    
  Then('the response should include name {string}, value {float} and an id' ) do |name, value|
    expect(@response.status).to eq 201  
    json_response = JSON.parse(@response.body)
    expect(json_response.dig('data', 'id').to_i).to be_an(Integer) 
    expect(json_response.dig('data', 'attributes', 'name')).to eq name
    expect(json_response.dig('data', 'attributes', 'value').to_f).to eq value
  end
  
  When('I submit a new metric with name {string}, value {float}, and timestamp {string}') do |name, value, timestamp|
      @response = post "/api/v1/metrics", { metric: { name: name, value: value, timestamp: timestamp } }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end

  Then('the response should include name {string}, value {float}, and timestamp {string}' ) do |name, value, timestamp|
    expect(@response.status).to eq 201
    json_response = JSON.parse(@response.body)
    expect(json_response.dig('data', 'attributes', 'name')).to eq name
    expect(json_response.dig('data', 'attributes', 'value').to_f).to eq value
    expect(json_response.dig('data', 'attributes', 'timestamp')).to eq timestamp
  end

  
  When('I submit a new metric with no name, value {float}') do |value|
    @response = post "/api/v1/metrics", { metric: { value: value } }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end

  Then('the response should indicate a validation error for missing name') do
    expect(@response.status).to eq 422
    json_response = JSON.parse(@response.body)
    expect(json_response['error']).to include('name')
  end
  
  When('I submit a new metric with name {string} and an invalid value') do |name|
     @response = post "/api/v1/metrics", { metric: {  name: name, value: "invalid"  } }.to_json, { 'CONTENT_TYPE' => 'application/json' }

  end
  
  Then('the response should indicate a validation error for the value') do
    expect(@response.status).to eq 422
    json_response = JSON.parse(@response.body)
    expect(json_response['error']).to include('value')
  end
  
