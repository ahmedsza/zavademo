Feature: Data Retrieval API
  As an API consumer
  I want to retrieve user data from the system
  So that I can access stored information

  Background:
    Given the API server is running on port 5000
    And the sample data file "sampledata.json" exists

  # Happy Path Scenarios
  Scenario: Retrieve user data successfully
    Given the sample data contains valid user records
    When I send a GET request to "/getdata"
    Then the response status code should be 200
    And the response should be valid JSON

  # Error Scenarios
  Scenario: Handle data retrieval with intentional errors
    Given the sample data file contains user records
    When I send a GET request to "/getdata"
    Then the system should attempt to process the data
    And error handling should catch type errors during processing
    And error handling should catch key errors for missing data
    And error handling should catch arithmetic errors

  Scenario: Retrieve data when file is missing
    Given the sample data file does not exist
    When I send a GET request to "/getdata"
    Then the response status code should be 500
    Or the system should return an appropriate error message

  Scenario: Retrieve data when file contains invalid JSON
    Given the sample data file contains invalid JSON
    When I send a GET request to "/getdata"
    Then the response status code should be 500
    Or the system should return a JSON parsing error
