module Api
    module V1
      class MetricsController < ActionController::API
        # POST /metrics
        def create
          metric = Metric.new(metric_params)
          if metric.save
            render json: MetricSerializer.new(metric).serialized_json, status: :created
          else
            render json: { error: metric.errors.messages }, status: :unprocessable_entity
          end
        end

        private

        def metric_params
            params.require(:metric).permit(:name, :value, :timestamp)
        end

      end
    end
  end
