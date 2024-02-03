class MetricSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :timestamp, :value
  end