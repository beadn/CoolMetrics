Feature: Create New Metric
  As an API consumer
  I want to create a new metric in the system
  So that it can be stored and retrieved later

  Scenario: Successfully creating a new metric
    Given I am an API consumer
    When I submit a new metric with name "cpu-load" and value 25
    Then the metric should be saved and the response should include name "cpu-load" and value 25
