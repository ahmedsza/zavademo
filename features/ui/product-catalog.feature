Feature: Product Catalog Browsing and Filtering
  As a customer
  I want to browse and filter products
  So that I can find items I'm interested in purchasing

  Background:
    Given I am on the products page
    And the product catalog has loaded
    And products are displayed in the grid

  # Happy Path Scenarios
  Scenario: View product catalog
    When I navigate to the products page
    Then I should see the products page title
    And I should see a search input field
    And I should see a category filter dropdown
    And I should see an "Add Product" button
    And I should see a products table or grid
    And I should see product loading state initially

  Scenario: Search for products by name
    Given the following products exist:
      | name                  | category    | price  |
      | Wireless Headphones   | Electronics | 299.99 |
      | Bluetooth Speaker     | Electronics | 149.99 |
      | Leather Wallet        | Accessories | 79.99  |
    When I enter "Headphones" in the search input
    Then I should see 1 product in the results
    And I should see "Wireless Headphones" in the results
    And I should not see "Bluetooth Speaker" in the results
    And I should not see "Leather Wallet" in the results

  Scenario: Search with partial product name
    Given products exist with names containing "Wireless"
    When I enter "Wire" in the search input
    Then I should see all products containing "Wire" in their name
    And the search should be case-insensitive

  Scenario: Filter products by category
    Given the following products exist:
      | name      | category    | price  |
      | Product A | Electronics | 100.00 |
      | Product B | Clothing    | 50.00  |
      | Product C | Electronics | 200.00 |
    When I select "Electronics" from the category filter
    Then I should see 2 products in the results
    And I should see "Product A" in the results
    And I should see "Product C" in the results
    And I should not see "Product B" in the results

  Scenario: View all categories in filter dropdown
    Given products exist in multiple categories
    When I open the category filter dropdown
    Then I should see "All Categories" as the first option
    And I should see all unique product categories listed
    And the categories should be sorted alphabetically

  Scenario: View product details in the catalog
    Given a product "Premium Watch" exists with:
      | field       | value                    |
      | description | Luxury timepiece         |
      | price       | 599.99                   |
      | category    | Accessories              |
    When I view the product in the catalog
    Then I should see the product name "Premium Watch"
    And I should see the price "$599.99"
    And I should see the category "Accessories"
    And I should see the description "Luxury timepiece"

  # Edge Cases
  Scenario: Search with no matching results
    Given products exist in the catalog
    When I enter "NonExistentProductName12345" in the search input
    Then I should see a "no products found" message
    And the products grid should be empty

  Scenario: View products page when no products exist
    Given the product catalog is empty
    When I navigate to the products page
    Then I should see an empty state
    And I should see a message indicating no products are available
    And the "Add Product" button should still be visible

  Scenario: Search with empty string
    Given products exist in the catalog
    When I clear the search input
    Then I should see all products in the catalog
    And no products should be filtered out

  Scenario: Filter by "All Categories"
    Given products exist in multiple categories
    And I have previously selected a specific category filter
    When I select "All Categories" from the filter dropdown
    Then I should see all products regardless of category
    And the filter should be reset

  Scenario Outline: Search with special characters
    Given products exist in the catalog
    When I enter "<search_term>" in the search input
    Then the search should handle special characters gracefully
    And the application should not crash

    Examples:
      | search_term            |
      | <script>alert(1)</script> |
      | Product & Co.          |
      | 50% Off!               |
      | Product's Name         |
      | "Quoted Product"       |

  # Combined Filtering
  Scenario: Combine search and category filter
    Given the following products exist:
      | name              | category    | price  |
      | Wireless Mouse    | Electronics | 29.99  |
      | Wireless Keyboard | Electronics | 79.99  |
      | Wireless Speaker  | Audio       | 99.99  |
    When I select "Electronics" from the category filter
    And I enter "Keyboard" in the search input
    Then I should see 1 product in the results
    And I should see "Wireless Keyboard" in the results

  # Error Scenarios
  Scenario: Handle API error when loading products
    Given the API server is unavailable
    When I navigate to the products page
    Then I should see an error message
    And the error message should indicate that products could not be loaded
    And the loading state should be hidden

  # Accessibility Scenarios
  Scenario: Navigate product catalog using keyboard only
    When I navigate the products page using only the keyboard
    Then I should be able to tab to the search input
    And I should be able to tab to the category filter
    And I should be able to tab to the "Add Product" button
    And I should be able to tab through all product cards
    And focus indicators should be visible on all elements

  Scenario: Search input has proper ARIA label
    When I inspect the search input field
    Then it should have an ARIA label or accessible name
    And screen readers should announce its purpose
    And the placeholder text should be descriptive

  Scenario: Category filter has proper ARIA label
    When I inspect the category filter dropdown
    Then it should have an ARIA label of "Filter by category"
    And screen readers should announce filter changes
    And the selected option should be announced
