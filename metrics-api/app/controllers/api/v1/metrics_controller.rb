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
        limit_clause = 1000
      
        # Validate time frame if present
        if params[:time_frame].present? && !['minute', 'hour', 'day'].include?(params[:time_frame])
          return render json: { error: 'Invalid time frame' }, status: :bad_request
        end
      
        @metrics = Metric.all.limit(limit_clause) # Assign @metrics instead of metrics
      
        # Conditionally filter by name if parameter is present
        @metrics = @metrics.where(name: params[:name]).limit(limit_clause) if params[:name].present?
      
        # Aggregate metrics based on time_frame if parameter is present
        if params[:time_frame].present?
          @metrics = aggregate_metrics(@metrics, params[:time_frame])
        end
      
        render json: MetricSerializer.new(@metrics).serialized_json
      end

      private

      def metric_params
        params.require(:metric).permit(:name, :value, :timestamp)
      end

      def aggregate_metrics(metrics, time_frame)
        interval = case time_frame
                   when 'minute' then 'minute'
                   when 'hour' then 'hour'
                   when 'day' then 'day'
                   end

        minimum_date = case time_frame
                   when 'minute' then Time.now - 60.minutes
                   when 'hour' then Time.now - 24.hours
                   when 'day' then Time.now - 7.days
                   else Time.now - 60.minutes # Default to last 60 minutes
                   end
    
   
        # Adjust the aggregation query to efficiently handle the grouping and selection
        select_statement = "date_trunc('#{interval}', timestamp) AS timestamp, AVG(value) AS value"
        group_by_clause = "date_trunc('#{interval}', timestamp)"
        metrics = metrics.select("name, #{select_statement}, COUNT(*) AS count").group("name, #{group_by_clause}").order("name, timestamp").where('timestamp > ?', minimum_date)
 
   metrics
  end
    end
  end
end
