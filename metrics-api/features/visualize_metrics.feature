Feature: Visualize Metrics Aggregated by Time Frame
  As an API consumer
  I want to retrieve metrics aggregated by a specified time frame
  So that I can analyze metric trends over time on a timeline

  Background: 
    Given there are existing metrics

  Scenario: Retrieve metrics aggregated by minute
    When I request all metrics to be aggregated by "minute"
    Then I should see all the metrics aggregated by "minute"

  Scenario: Retrieve metrics aggregated by hour
    When I request all metrics to be aggregated by "hour"
    Then I should see all the metrics aggregated by "hour"

  Scenario: Retrieve metrics aggregated by day
    When I request all metrics to be aggregated by "day"
    Then I should see all the metrics aggregated by "day"

  Scenario: Retrieve metrics by name aggregated by day
    When I request all metrics for "memory-usage" to be aggregated by "day"
    Then the aggregation should include only "memory-usage" metrics
