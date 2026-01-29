Feature: Contact Form Submission
  As a visitor
  I want to submit a contact form
  So that I can communicate with the Zava team

  Background:
    Given I am on the contact page
    And the contact form is displayed

  # Happy Path Scenarios
  Scenario: View contact page
    When I navigate to the contact page
    Then I should see the contact page title
    And I should see contact information including:
      | element     |
      | phone       |
      | email       |
      | address     |
    And I should see a contact form

  Scenario: Submit contact form with all fields filled
    When I fill in the contact form with:
      | field   | value                  |
      | name    | John Doe               |
      | email   | john@example.com       |
      | subject | Product Inquiry        |
      | message | I have a question...   |
    And I submit the contact form
    Then I should see a success message
    And the form should be reset

  # Edge Cases
  Scenario: Submit form with minimum required information
    When I fill in only the required contact form fields
    And I submit the contact form
    Then the form should be submitted successfully
    And I should see a confirmation message

  # Error Scenarios
  Scenario: Submit form with missing required fields
    When I submit the contact form without filling any fields
    Then I should see validation errors
    And the form should not be submitted
    And I should see error messages for required fields

  Scenario: Submit form with invalid email format
    When I fill in the contact form with:
      | field   | value              |
      | name    | John Doe           |
      | email   | invalid-email      |
      | message | Test message       |
    And I submit the contact form
    Then I should see an email validation error
    And the form should not be submitted

  # Accessibility Scenarios
  Scenario: Navigate contact form using keyboard only
    When I navigate the contact form using only the keyboard
    Then I should be able to tab through all form fields
    And I should be able to submit the form using Enter
    And focus indicators should be visible

  Scenario: Contact form has proper labels and ARIA
    When I inspect the contact form
    Then all input fields should have associated labels
    And required fields should be marked with ARIA required
    And error messages should be linked to their fields
