Feature: Homepage Navigation and Display
  As a visitor
  I want to navigate the Zava e-commerce website
  So that I can explore products and information

  Background:
    Given I am on the Zava homepage at "/"
    And the page has finished loading

  # Happy Path Scenarios
  Scenario: View homepage hero section
    When I am on the homepage
    Then I should see the hero section with "ZAVA"
    And I should see the tagline about curated collections
    And I should see a "SHOP NOW" button
    And I should see a "LEARN MORE" button

  Scenario: Navigate to products page from homepage
    When I am on the homepage
    And I click on the "SHOP NOW" button
    Then I should be on the products page
    And I should see the products grid
    And I should see product filtering options

  Scenario: Navigate to about page from homepage
    When I am on the homepage
    And I click on the "LEARN MORE" button
    Then I should be on the about page
    And I should see information about Zava

  Scenario: View featured products on homepage
    Given products exist in the system
    When I am on the homepage
    Then I should see a "Featured Products" section
    And I should see product cards displayed in a grid
    And each product card should show:
      | element     |
      | name        |
      | description |
      | price       |
      | category    |

  Scenario: Navigate using main navigation menu
    When I am on the homepage
    And I click on "Home" in the navigation menu
    Then I should remain on the homepage
    When I click on "About" in the navigation menu
    Then I should be on the about page
    When I click on "Products" in the navigation menu
    Then I should be on the products page
    When I click on "Stores" in the navigation menu
    Then I should be on the stores page
    When I click on "Contact" in the navigation menu
    Then I should be on the contact page

  # Mobile Scenarios
  Scenario: Toggle mobile menu
    Given I am viewing the site on a mobile device
    When I click on the mobile menu toggle button
    Then the mobile menu should be visible
    And I should see all navigation links
    When I click on the mobile menu toggle button again
    Then the mobile menu should be hidden

  # Edge Cases
  Scenario: View homepage with no featured products
    Given no products exist in the system
    When I am on the homepage
    Then I should see the featured products section
    And I should see a message indicating no products are available

  # Accessibility Scenarios
  Scenario: Navigate homepage using keyboard only
    When I navigate the homepage using only the keyboard
    Then I should be able to tab through all interactive elements
    And the "SHOP NOW" button should be keyboard accessible
    And the "LEARN MORE" button should be keyboard accessible
    And all navigation menu items should be keyboard accessible
    And focus indicators should be visible

  Scenario: Screen reader announces homepage elements
    When I access the homepage with a screen reader
    Then the navigation menu should have appropriate ARIA labels
    And the mobile menu toggle should have an accessible label
    And buttons should announce their purpose
    And images should have alt text
