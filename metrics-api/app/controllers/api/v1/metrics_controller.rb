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


      # GET /metrics
      def index
        if params[:name]
          metrics = Metric.where(name: params[:name])
        else
          metrics = Metric.all
        end

        render json: MetricSerializer.new(metrics).serialized_json
      end

        private

        def render_not_found
          render json: { error: 'Metric not found' }, status: :not_found
        end

        def metric_params
            params.require(:metric).permit(:name, :value, :timestamp)
        end

      end
    end
  end
