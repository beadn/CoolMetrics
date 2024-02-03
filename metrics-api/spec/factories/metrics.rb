FactoryBot.define do
  factory :metric do
    timestamp { Time.current }
    name { ["cpu-usage", "memory-usage", "disk-usage", "network-traffic", "database-load"].sample }
    value { rand(1..100) }
  end
end
