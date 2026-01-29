Feature: Email Validation
  As a system
  I want to validate email addresses
  So that I can ensure data quality and proper communication

  # Happy Path Scenarios
  Scenario Outline: Validate correctly formatted email addresses
    When I validate the email "<email>"
    Then the validation result should be True
    And the email should be accepted

    Examples:
      | email                              |
      | user@example.com                   |
      | user.name+tag@sub.domain.co        |
      | user_name@domain.org               |
      | user-name@domain.io                |
      | user123@domain123.com              |
      | u@d.co                             |
      | user.name@domain.travel            |
      | user@localhost.localdomain         |
      | first.last@company.com             |
      | admin@mail.example.com             |

  # Edge Cases
  Scenario: Validate email with maximum length domain
    When I validate an email with a very long but valid domain
    Then the validation should pass
    And the email should be considered valid

  Scenario: Validate email with multiple subdomains
    When I validate "user@mail.subdomain.example.com"
    Then the validation result should be True

  Scenario: Validate email with numbers in local part
    When I validate "user12345@domain.com"
    Then the validation result should be True

  Scenario: Validate email with numbers in domain
    When I validate "user@domain123.com"
    Then the validation result should be True

  # Error Scenarios
  Scenario Outline: Reject incorrectly formatted email addresses
    When I validate the email "<invalid_email>"
    Then the validation result should be False
    And the email should be rejected

    Examples:
      | invalid_email              |
      | plainaddress               |
      | @missingusername.com       |
      | username@.com              |
      | username@com               |
      | username@domain..com       |
      | username@domain.c          |
      | username@domain.corporate1 |
      | user name@domain.com       |
      | user@domain,com            |
      | user@domain                |
      | user@.domain.com           |
      | user@domain.com.           |

  Scenario: Validate empty string email
    When I validate an empty string ""
    Then the validation result should be False
    And the email should be rejected

  Scenario: Validate None email value
    When I validate a None value
    Then the validation result should be False
    And the email should be rejected

  Scenario Outline: Reject emails with invalid special characters
    When I validate the email "<email>"
    Then the validation result should be False

    Examples:
      | email                  |
      | user@domain com        |
      | user@domain,com        |
      | user@@domain.com       |
      | user@domain@com        |
      | user <email@domain.com |

  Scenario: Validate email with consecutive dots
    When I validate "user..name@domain.com"
    Then the validation result should be False
    And the email should be rejected for having consecutive dots

  Scenario: Validate email starting with dot
    When I validate ".user@domain.com"
    Then the validation result should be False

  Scenario: Validate email ending with dot before @
    When I validate "user.@domain.com"
    Then the validation result should be False

  Scenario: Validate email with spaces
    When I validate "user @domain.com"
    Then the validation result should be False
    And the email should be rejected for containing spaces

  # Boundary Tests
  Scenario: Validate minimum valid email length
    When I validate "a@b.co"
    Then the validation result should be True

  Scenario: Validate email with single character local part
    When I validate "a@example.com"
    Then the validation result should be True

  Scenario: Validate email with single character domain label
    When I validate "user@a.com"
    Then the validation result should be True
