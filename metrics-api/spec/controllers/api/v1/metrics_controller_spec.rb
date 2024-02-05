require 'rails_helper'

RSpec.describe Api::V1::MetricsController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) { { metric: { name: 'cpu-usage', value: 50.0, timestamp: DateTime.now } } }
    let(:invalid_params) { { metric: { name: '', value: '', timestamp: '' } } }

    context 'with valid attributes' do
      it 'creates a new metric' do
        # Stub the Metric.new and save methods
        metric_double = instance_double('Metric', save: true, id: 1, name: 'cpu-usage',value: 50.0,timestamp: DateTime.now )
        allow(Metric).to receive(:new).and_return(metric_double)

        post :create, params: valid_params

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new metric' do
        # Stub the Metric.new method
        errors_double = instance_double('Errors', messages: { name: ['cannot be blank'] })
        metric_double = instance_double('Metric', save: false, errors: errors_double)
        allow(Metric).to receive(:new).and_return(metric_double)


        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      # Stub the Metric.all method
      relation_double = instance_double('ActiveRecord::Relation', limit: [])
      allow(Metric).to receive(:all).and_return(relation_double)

      get :index

      expect(response).to have_http_status(:success)
    end

    it 'assigns @metrics with a list of metrics' do
        # Create test data or use a factory to generate metrics
        metric1 = create(:metric, name: 'cpu-usage', value: 50.0)
        metric2 = create(:metric, name: 'memory-usage', value: 60.0)
      
        # Prepare a double for the ActiveRecord::Relation
        metrics_relation_double = instance_double('ActiveRecord::Relation')
      
        # Stub the Metric.all method to return the relation double
        allow(Metric).to receive(:all).and_return(metrics_relation_double)
      
        # Stub the limit method to return the actual metrics
        allow(metrics_relation_double).to receive(:limit).and_return([metric1, metric2])
      
        get :index
      
        expect(assigns(:metrics)).to match_array([metric1, metric2])
      end

  end
end
