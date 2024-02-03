require 'rails_helper'

RSpec.describe Metric, type: :model do
  # Test validations
  it 'is valid with valid attributes' do
    metric = Metric.new(name: 'cpu-usage', value: 50.0, timestamp: DateTime.now)
    expect(metric).to be_valid
  end

  it 'is not valid without a name' do
    metric = Metric.new(name: nil, value: 50.0)
    expect(metric).to_not be_valid
  end

  it 'is not valid without a value' do
    metric = Metric.new(name: 'cpu-usage', value: nil)
    expect(metric).to_not be_valid
  end

  it 'is valid without a timestamp' do
    metric = Metric.new(name: 'cpu-usage', value: 50.0)
    expect(metric).to be_valid
  end

  # Test normalization
  it 'normalizes the name before saving' do
    metric = Metric.create(name: 'CPU Usage', value: 50.0)
    expect(metric.reload.name).to eq('cpu-usage')
  end

  it 'rounds the value to two decimal places' do
    metric = Metric.create(name: 'cpu-usage', value: 50.1234)
    expect(metric.reload.value).to eq(50.12)
  end

  # Test automatic timestamp assignment
  it 'assigns a timestamp if not provided' do
    metric = Metric.create(name: 'cpu-usage', value: 50.0)
    expect(metric.timestamp).to_not be_nil
  end
end
