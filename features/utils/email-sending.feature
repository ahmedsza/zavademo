Feature: Email Sending via SMTP
  As a system
  I want to send emails via SMTP
  So that I can communicate with users

  Background:
    Given the SMTP configuration is loaded from environment variables
    And the SMTPEmailSender is initialized

  # Happy Path Scenarios
  Scenario: Send simple text email to single recipient
    Given I have a valid SMTP configuration
    When I send an email with:
      | field     | value                              |
      | to_email  | recipient@example.com              |
      | body      | This is a test email body          |
    Then the email should be sent successfully
    And the return value should be True
    And a success message should be logged

  Scenario: Send HTML email with text fallback
    Given I have a valid SMTP configuration
    When I send an email with:
      | field      | value                           |
      | to_email   | recipient@example.com           |
      | body       | Plain text version              |
      | html_body  | <html><body>HTML version</body> |
    Then the email should be sent successfully
    And both plain text and HTML parts should be included
    And the return value should be True

  Scenario: Send email to multiple recipients
    Given I have a valid SMTP configuration
    When I send an email to the following recipients:
      | email                  |
      | user1@example.com      |
      | user2@example.com      |
      | user3@example.com      |
    And the body is "Multi-recipient test"
    Then the email should be sent to all recipients
    And all recipients should be in the "To" field
    And the return value should be True

  Scenario: Send email with attachment
    Given I have a valid SMTP configuration
    And a file "test-attachment.txt" exists
    When I send an email with:
      | field       | value                    |
      | to_email    | recipient@example.com    |
      | body        | Email with attachment    |
      | attachments | ["test-attachment.txt"]  |
    Then the email should be sent successfully
    And the attachment should be included
    And the attachment should be base64 encoded
    And the return value should be True

  Scenario: Send email with multiple attachments
    Given I have a valid SMTP configuration
    And multiple files exist:
      | filename         |
      | document.pdf     |
      | image.jpg        |
      | data.csv         |
    When I send an email with all three attachments
    Then the email should be sent successfully
    And all attachments should be included
    And the return value should be True

  # Edge Cases
  Scenario: Send email with empty body
    Given I have a valid SMTP configuration
    When I send an email with:
      | field    | value                 |
      | to_email | recipient@example.com |
      | body     |                       |
    Then the email should be sent successfully
    And the body should be empty but valid

  Scenario: Send email with very long body
    Given I have a valid SMTP configuration
    When I send an email with a body of 10000 characters
    Then the email should be sent successfully
    And the entire body should be transmitted

  Scenario: Send email with special characters in body
    Given I have a valid SMTP configuration
    When I send an email with body containing "Special chars: é, ñ, ü, 中文, 🎉"
    Then the email should be sent successfully
    And special characters should be properly encoded

  Scenario: Send email with HTML containing complex formatting
    Given I have a valid SMTP configuration
    When I send an email with complex HTML including:
      | element        |
      | tables         |
      | images         |
      | CSS styles     |
      | nested divs    |
    Then the email should be sent successfully
    And the HTML should be properly formatted

  # Configuration Scenarios
  Scenario: Initialize SMTPEmailSender with valid environment variables
    Given the following environment variables are set:
      | variable       | value                  |
      | SMTP_HOST      | smtp.example.com       |
      | SMTP_PORT      | 587                    |
      | SMTP_USERNAME  | username               |
      | SMTP_PASSWORD  | password               |
      | FROM_EMAIL     | sender@example.com     |
      | FROM_NAME      | Sender Name            |
    When I initialize the SMTPEmailSender
    Then the initialization should succeed
    And all configuration should be loaded correctly

  Scenario: Use default SMTP port when not specified
    Given SMTP_PORT is not set in environment variables
    When I initialize the SMTPEmailSender
    Then the SMTP port should default to 587

  # Error Scenarios - Configuration
  Scenario: Initialize without required SMTP configuration
    Given SMTP_HOST is not set in environment variables
    When I attempt to initialize the SMTPEmailSender
    Then a ValueError should be raised
    And the error message should indicate missing SMTP configuration

  Scenario Outline: Initialize with missing required fields
    Given the environment variable "<missing_var>" is not set
    When I attempt to initialize the SMTPEmailSender
    Then a ValueError should be raised
    And the error should indicate missing configuration

    Examples:
      | missing_var    |
      | SMTP_HOST      |
      | SMTP_USERNAME  |
      | SMTP_PASSWORD  |
      | FROM_EMAIL     |

  # Error Scenarios - Sending
  Scenario: Send email with invalid recipient address
    Given I have a valid SMTP configuration
    When I attempt to send an email to "invalid-email"
    Then the send should fail
    And the return value should be False
    And an error message should be logged

  Scenario: Send email when SMTP server is unreachable
    Given the SMTP server is not reachable
    When I attempt to send an email
    Then the send should fail
    And a connection error should be caught
    And the return value should be False
    And an appropriate error message should be logged

  Scenario: Send email with incorrect credentials
    Given the SMTP credentials are invalid
    When I attempt to send an email
    Then authentication should fail
    And the return value should be False
    And an authentication error should be logged

  Scenario: Send email with non-existent attachment
    Given I have a valid SMTP configuration
    When I attempt to send an email with attachment "non-existent.txt"
    Then the attachment should be skipped
    Or an error should be logged
    And the email may still be sent without the attachment

  Scenario: Send email when attachment file cannot be read
    Given I have a valid SMTP configuration
    And an attachment file exists but is not readable
    When I attempt to send an email with that attachment
    Then an appropriate error should be handled
    And the return value should reflect the failure

  # Security Scenarios
  Scenario: Verify STARTTLS is used for secure connection
    Given I have a valid SMTP configuration
    When I send an email
    Then STARTTLS should be enabled
    And the connection should be encrypted

  Scenario: Verify credentials are not logged
    Given I have a valid SMTP configuration
    When I send an email
    Then the SMTP password should not appear in logs
    And the SMTP username should not appear in error messages

  Scenario: Send email with potential injection attempt in subject
    Given I have a valid SMTP configuration
    When I attempt to send an email with malicious subject headers
    Then the headers should be sanitized
    And no email injection should be possible

  # Performance Scenarios
  Scenario: Send email completes within reasonable time
    Given I have a valid SMTP configuration
    When I send a standard email
    Then the operation should complete within 10 seconds
    And the email should be delivered successfully

  Scenario: Send multiple emails sequentially
    Given I have a valid SMTP configuration
    When I send 10 emails sequentially
    Then all emails should be sent successfully
    And each should maintain its own SMTP session
    And connections should be properly closed
