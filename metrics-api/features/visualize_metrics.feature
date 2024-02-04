Feature: Visualize Metrics
  As an API consumer
  I want to retrieve aggregated metrics by Time Frame
  So that I can view them on a timeline

 Scenario: Retrieve all metrics aggregated by Minute
    Given there are existing metrics
    When I request all metrics with Time Frame "minute"
    Then I should see all the metrics aggregated by minutes

Scenario: Retrieve all metrics aggregated by Hour
    Given there are existing metrics
    When I request all metrics with Time Frame "hour"
    Then I should see all the metrics aggregated by hour


Scenario: Retrieve all metrics aggregated by day
    Given there are existing metrics
    When I request all metrics with Time Frame "day"
    Then I should see all the metrics aggregated by day
