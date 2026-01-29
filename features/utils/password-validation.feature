Feature: Password Validation and Security
  As a system
  I want to validate and hash passwords
  So that I can ensure secure user authentication

  # Happy Path Scenarios - Password Strength Validation
  Scenario: Validate strong password with all requirements
    When I validate the password "SecurePass123!"
    Then the validation result should be True
    And the password should be considered strong

  Scenario Outline: Validate various strong passwords
    When I validate the password "<password>"
    Then the validation result should be True
    And the password should meet all strength requirements

    Examples:
      | password           |
      | MyP@ssw0rd         |
      | Complex#Pass123    |
      | Str0ng!Password    |
      | Valid#123Pass      |
      | SecureP@ss99       |

  # Error Scenarios - Password Too Short
  Scenario Outline: Reject passwords shorter than 8 characters
    When I validate the password "<password>"
    Then the validation result should be False
    And the error should indicate password is too short

    Examples:
      | password  |
      | Short1!   |
      | Pass1!    |
      | Abc123!   |
      | Test@1    |

  # Error Scenarios - Missing Required Character Types
  Scenario: Reject password without uppercase letters
    When I validate the password "weakpass123!"
    Then the validation result should be False
    And the error should indicate missing uppercase letter

  Scenario: Reject password without lowercase letters
    When I validate the password "WEAKPASS123!"
    Then the validation result should be False
    And the error should indicate missing lowercase letter

  Scenario: Reject password without numbers
    When I validate the password "WeakPassword!"
    Then the validation result should be False
    And the error should indicate missing number

  Scenario: Reject password without special characters
    When I validate the password "WeakPassword123"
    Then the validation result should be False
    And the error should indicate missing special character

  Scenario Outline: Reject passwords missing multiple requirements
    When I validate the password "<password>"
    Then the validation result should be False
    And the password should be rejected

    Examples:
      | password       |
      | password       |
      | PASSWORD       |
      | 12345678       |
      | !!!!!!!!!      |
      | Password       |
      | password123    |
      | PASSWORD123    |

  # Edge Cases
  Scenario: Validate password exactly 8 characters with all requirements
    When I validate the password "Pass123!"
    Then the validation result should be True

  Scenario: Validate very long strong password
    When I validate a password with 50 characters including all required types
    Then the validation result should be True

  Scenario: Validate password with multiple special characters
    When I validate the password "P@ssw0rd!#$%"
    Then the validation result should be True

  Scenario: Validate password with spaces
    When I validate the password "Pass word 123!"
    Then the validation result should be True
    And spaces should be allowed as special characters

  # Happy Path Scenarios - Password Hashing
  Scenario: Hash a valid password
    Given I have a password "MySecurePassword123!"
    When I hash the password
    Then I should receive a SHA-256 hash
    And the hash should be 64 characters long
    And the hash should be hexadecimal

  Scenario: Hash same password produces same hash
    Given I have a password "TestPassword123!"
    When I hash the password multiple times
    Then all hash results should be identical
    And the hashing should be deterministic

  Scenario: Hash different passwords produce different hashes
    Given I have two different passwords "Password123!" and "Password124!"
    When I hash both passwords
    Then the hash results should be different
    And each hash should be unique

  # Edge Cases - Hashing
  Scenario: Hash empty password
    When I hash an empty string password
    Then I should receive a valid hash
    And the hash should still be 64 characters

  Scenario: Hash password with special characters
    When I hash the password "P@$$w0rd!#%^&*()"
    Then I should receive a valid hash
    And special characters should be properly encoded

  Scenario: Hash password with unicode characters
    When I hash the password "Pāsswörd123!♠"
    Then I should receive a valid hash
    And unicode characters should be properly handled

  Scenario: Hash very long password
    When I hash a password with 1000 characters
    Then I should receive a valid hash
    And the hash length should still be 64 characters

  # Security Scenarios
  Scenario: Verify hashed password cannot be reversed
    Given I have hashed the password "SecretPassword123!"
    When I attempt to reverse the hash
    Then it should be computationally infeasible
    And the original password should not be recoverable

  Scenario: Verify hash is consistent across system restarts
    Given I have a password "Persistent123!"
    When I hash it before and after system restart
    Then both hashes should be identical
    And the hash should be deterministic
