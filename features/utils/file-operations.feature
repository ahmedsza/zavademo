Feature: File Operations and Logging
  As a system
  I want to perform file operations and logging
  So that I can track events and manage files

  Background:
    Given the filesystem is accessible
    And I have appropriate file permissions

  # Happy Path Scenarios - Logging
  Scenario: Log a simple message
    Given a log file "log.txt" exists or can be created
    When I log the message "Test log entry"
    Then the message should be appended to "log.txt"
    And the message should include a newline character
    And the file should be readable

  Scenario: Log multiple messages sequentially
    Given a log file exists
    When I log the following messages:
      | message           |
      | First log entry   |
      | Second log entry  |
      | Third log entry   |
    Then the log file should contain all three messages
    And messages should be in the order they were logged
    And each message should be on a separate line

  Scenario: Log message with special characters
    When I log the message "Error: Exception occurred @#$%^&*()"
    Then the special characters should be preserved in the log
    And the log entry should be readable

  Scenario: Read log file contents
    Given the log file contains multiple entries
    When I read the log file
    Then I should receive all log entries
    And the entries should be in the correct order
    And the content should be UTF-8 encoded

  # Edge Cases - Logging
  Scenario: Log empty message
    When I log an empty string ""
    Then an empty line should be added to the log
    And the file should still be valid

  Scenario: Log very long message
    When I log a message with 10000 characters
    Then the entire message should be written to the log
    And the log file should remain accessible

  Scenario: Log message with newlines
    When I log a message containing "\n" characters
    Then the message should be written as-is
    And additional newlines should be preserved

  Scenario: Append to existing non-empty log file
    Given the log file already contains entries
    When I log a new message "New entry"
    Then the new message should be appended
    And existing log entries should be preserved
    And the file should not be overwritten

  # Happy Path Scenarios - Unique Filename Generation
  Scenario: Generate unique filename for a simple file
    When I generate a unique filename for "demo.jpg"
    Then the output should be in format "demo_<timestamp>.jpg"
    And the timestamp should be in format "YYYYMMDDHHMMSSffffff"
    And the file extension should be preserved

  Scenario Outline: Generate unique filenames for various file types
    When I generate a unique filename for "<original_filename>"
    Then the base filename should be preserved
    And a timestamp should be inserted before the extension
    And the extension should be "<extension>"

    Examples:
      | original_filename  | extension |
      | document.pdf       | .pdf      |
      | image.png          | .png      |
      | data.csv           | .csv      |
      | archive.tar.gz     | .gz       |
      | script.py          | .py       |

  Scenario: Generate multiple unique filenames
    When I generate unique filenames for "file.txt" three times
    Then each filename should be different
    And all filenames should include timestamps
    And the base name and extension should be consistent

  Scenario: Generate filename preserves directory path
    When I generate a unique filename for "path/to/file.txt"
    Then the base path should be "path/to/file"
    And the timestamp should be inserted
    And the extension should be ".txt"

  # Edge Cases - Unique Filename Generation
  Scenario: Generate filename for file without extension
    When I generate a unique filename for "README"
    Then the output should be "README_<timestamp>"
    And no file extension should be added

  Scenario: Generate filename for hidden file
    When I generate a unique filename for ".gitignore"
    Then the output should be ".gitignore_<timestamp>"
    And the dot prefix should be preserved

  Scenario: Generate filename for file with multiple dots
    When I generate a unique filename for "archive.tar.gz"
    Then the base should be "archive.tar"
    And the extension should be ".gz"
    And the timestamp should be inserted correctly

  Scenario: Generate filename with special characters in name
    When I generate a unique filename for "my-file_v2.txt"
    Then special characters should be preserved
    And the timestamp should be inserted before extension

  Scenario: Verify timestamp uniqueness
    When I generate two filenames in rapid succession
    Then the timestamps should be different
    And the microsecond precision should ensure uniqueness

  # Error Scenarios - Logging
  Scenario: Handle permission denied when writing log
    Given I don't have write permissions for the log file
    When I attempt to log a message
    Then an appropriate error should be raised
    And the error should indicate permission issues

  Scenario: Handle disk full scenario
    Given the disk is full
    When I attempt to log a message
    Then an IOError should be raised
    And the error should indicate insufficient space

  # Error Scenarios - Reading Log
  Scenario: Read non-existent log file
    Given the log file "log.txt" does not exist
    When I attempt to read the log file
    Then a FileNotFoundError should be raised
    And an appropriate error message should be provided

  Scenario: Read log file with incorrect permissions
    Given I don't have read permissions for the log file
    When I attempt to read the log file
    Then a PermissionError should be raised

  # Security Scenarios
  Scenario: Log message sanitization
    When I log a message containing user input
    Then the message should be written safely
    And no code injection should be possible
    And the log file should remain valid

  Scenario: Verify log file is not executable
    After logging messages
    Then the log file should not have execute permissions
    And the file should be a plain text file
