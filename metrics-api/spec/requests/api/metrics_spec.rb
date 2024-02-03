require 'swagger_helper'

describe 'Metrics API' do

  path '/api/v1/metrics' do

    post 'Creates a metric' do
      tags 'Metrics'
      consumes 'application/json'
      parameter name: :metric, in: :body, schema: {
        type: :object,
        properties: {
          metric: {
            type: :object,
            properties: {
              name: { type: :string },
              value: { type: :string },
              timestamp: { type: :string, format: :datetime },
            },
            required: ['name', 'value', 'timestamp']
          }
        },
        required: ['metric']
      }

      response '201', 'metric created' do
        let(:metric) { { name: 'New Metric', value: '100', timestamp: '2023-01-01T00:00:00Z' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:metric) { { name: '', value: '', timestamp: '' } } # Assuming this leads to validation errors
        run_test!
      end
    end


    get 'Retrieves metrics' do
      tags 'Metrics'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string, required: false, description: 'Name of the metric to filter by'

      response '200', 'metrics found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string },
                       attributes: {
                         type: :object,
                         properties: {
                           name: { type: :string },
                           value: { type: :number },
                           timestamp: { type: :string, format: 'date-time' }
                         }
                       }
                     }
                   }
                 }
               }
        run_test!
      end
    end
  end
end