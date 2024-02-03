Feature: Retrieve Metrics
  As an API consumer
  I want to retrieve metrics
  So that I can view them on a timeline

 Scenario: Retrieve all metrics
    Given there are existing metrics
    When I request all metrics
    Then I should see all the metrics

 Scenario: Retrieve metrics filtered by name
    Given there are existing metrics with name "cpu-load"
    When I request all metrics with name "cpu-load"
    Then I should see all the metrics named "cpu-load"
