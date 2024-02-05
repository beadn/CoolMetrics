require 'faker'

metric_names = ["cpu-load", "memory-usage", "disk-usage", "network-traffic", "database-load"]

# Generate data for the last 30 days
30.times do |i|
  date = 30.days.ago.beginning_of_day + i.days

  # Generate 10 random metrics for each day
  10.times do |j|
    Metric.create(
      name: metric_names.sample, # Randomly select a metric name
      value: Faker::Number.between(from: 1, to: 100), # Generate a random value
      timestamp: date + j.hours # Increment the timestamp by hour within the day to spread out the metrics
    )
  end
end

# Generate 2 metrics for each hour in the last 24 hours
24.times do |i|
  hour = 24.hours.ago + i.hours

  2.times do
    Metric.create(
      name: metric_names.sample,
      value: Faker::Number.between(from: 1, to: 100),
      timestamp: hour + rand(0..59).minutes # Random minute within the hour
    )
  end
end

# Generate 2 Metrics for each minute in the last 60 minutes
60.times do |i|
  minute = 60.minutes.ago + i.minutes

  2.times do
    Metric.create(
      name: metric_names.sample,
      value: Faker::Number.between(from: 1, to: 100),
      timestamp: minute # Set the timestamp to the exact minute
    )
  end
end

puts "Generated metric data for the last 30 days, last 24 hours, and last 60 minutes."


