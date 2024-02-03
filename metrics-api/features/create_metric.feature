Feature: Create New Metric
  As an API consumer
  I want to create a new metric in the system
  So that it can be stored and retrieved later

  Scenario: Successfully creating a new metric
    Given I am an API consumer
    When I submit a new metric with name "cpu-load" and value 25
    Then the response should include name "cpu-load", value 25 and an id

  Scenario: Successfully creating a new metric with a provided timestamp
    Given I am an API consumer
    When I submit a new metric with name "cpu-load", value 25, and timestamp "2024-01-01T00:00:00.000Z"
    Then the response should include name "cpu-load", value 25, and timestamp "2024-01-01T00:00:00.000Z"

  Scenario: Attempting to create a metric with missing name
    Given I am an API consumer
    When I submit a new metric with no name, value 25
    Then the response should indicate a validation error for missing name

  Scenario: Attempting to create a metric with invalid value
    Given I am an API consumer
    When I submit a new metric with name "memory-usage" and an invalid value
    Then the response should indicate a validation error for the value
