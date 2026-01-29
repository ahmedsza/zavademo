Feature: Newsletter Subscription
  As a visitor
  I want to subscribe to the newsletter
  So that I can receive updates and promotions

  Background:
    Given I am on the Zava website
    And the newsletter subscription form is visible in the footer

  # Happy Path Scenarios
  Scenario: Subscribe to newsletter with valid email
    When I enter "customer@example.com" in the newsletter email field
    And I click the "Subscribe" button
    Then I should see a success message
    And the message should confirm my subscription
    And the email field should be cleared

  # Edge Cases
  Scenario: Subscribe with email containing special characters
    When I enter "user+tag@example.co.uk" in the newsletter email field
    And I click the "Subscribe" button
    Then the subscription should be successful
    And I should see a confirmation message

  # Error Scenarios
  Scenario: Submit newsletter form without email
    When I click the "Subscribe" button without entering an email
    Then I should see a validation error
    And the error should indicate email is required

  Scenario: Submit newsletter form with invalid email
    When I enter "not-an-email" in the newsletter email field
    And I click the "Subscribe" button
    Then I should see a validation error
    And the error should indicate invalid email format

  Scenario Outline: Attempt to subscribe with various invalid emails
    When I enter "<invalid_email>" in the newsletter email field
    And I click the "Subscribe" button
    Then I should see an email validation error

    Examples:
      | invalid_email       |
      | plainaddress        |
      | @missinguser.com    |
      | user@              |
      | user@domain        |
      | user name@test.com  |

  # Accessibility Scenarios
  Scenario: Newsletter form is keyboard accessible
    When I navigate to the newsletter subscription using only keyboard
    Then I should be able to tab to the email input field
    And I should be able to tab to the subscribe button
    And I should be able to submit using Enter
    And focus indicators should be visible

  Scenario: Newsletter form has proper ARIA labels
    When I inspect the newsletter subscription form
    Then the email input should have an accessible label or placeholder
    And the subscribe button should have descriptive text
    And validation errors should be announced to screen readers
