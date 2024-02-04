require 'faker'

metric_names = ["cpu-load", "memory-usage", "disk-usage", "network-traffic", "database-load"]

# Generate data for the last 30 days
30.times do |i|
  date = 30.days.ago + i.days

  # Generate 10 random metrics for each day
  10.times do
    Metric.create(
      name: metric_names.sample, # Randomly select a metric name
      value: Faker::Number.between(from: 1, to: 100), # Generate a random value
      timestamp: date # Set the timestamp to the current day in the iteration
    )
  end
end

puts "Generated metric data for the last 30 days."

