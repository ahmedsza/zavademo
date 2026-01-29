Feature: Product Management Operations
  As an administrator
  I want to create, edit, and delete products
  So that I can maintain the product catalog

  Background:
    Given I am on the products page
    And I have administrative access

  # Happy Path Scenarios - Create Product
  Scenario: Open the product creation modal
    When I click on the "Add Product" button
    Then the product modal should open
    And the modal title should be "ADD NEW PRODUCT"
    And I should see an empty product form with fields:
      | field       |
      | name        |
      | description |
      | price       |
      | category    |
    And the submit button should say "ADD PRODUCT"

  Scenario: Create a new product with all fields
    When I click on the "Add Product" button
    And I fill in the product form with:
      | field       | value                        |
      | name        | Ergonomic Office Chair       |
      | description | Comfortable mesh back chair  |
      | price       | 349.99                       |
      | category    | Furniture                    |
    And I submit the product form
    Then I should see a success message
    And the modal should close
    And the product "Ergonomic Office Chair" should appear in the catalog
    And the products list should refresh

  Scenario: Create a product with only required fields
    When I click on the "Add Product" button
    And I fill in the product name with "Minimal Product"
    And I submit the product form
    Then I should see a success message
    And the product "Minimal Product" should appear in the catalog
    And the product should have default values for optional fields

  Scenario: View available categories in product form
    When I click on the "Add Product" button
    And I open the category dropdown
    Then I should see the following category options:
      | category    |
      | General     |
      | Electronics |
      | Clothing    |
      | Furniture   |
      | Accessories |
      | Sports      |
      | Books       |
      | Home        |
      | Other       |

  # Happy Path Scenarios - Edit Product
  Scenario: Open the edit product modal
    Given a product "Original Product Name" exists in the catalog
    When I click the edit button for "Original Product Name"
    Then the product modal should open
    And the modal title should be "EDIT PRODUCT"
    And the form fields should be pre-filled with the product data
    And the submit button should say "UPDATE PRODUCT"

  Scenario: Edit an existing product
    Given a product exists with:
      | field       | value              |
      | name        | Old Product Name   |
      | description | Old description    |
      | price       | 100.00             |
      | category    | Old Category       |
    When I click the edit button for the product
    And I update the product form with:
      | field       | value                |
      | name        | New Product Name     |
      | description | Updated description  |
      | price       | 150.00               |
      | category    | Electronics          |
    And I submit the product form
    Then I should see a success message
    And the modal should close
    And the product should display the updated information
    And the products list should refresh

  Scenario: Edit product name only
    Given a product "Product to Edit" exists
    When I edit the product
    And I change only the name to "Renamed Product"
    And I submit the product form
    Then the product name should be updated to "Renamed Product"
    And all other fields should remain unchanged

  # Happy Path Scenarios - Delete Product
  Scenario: Delete a product with confirmation
    Given a product "Product to Delete" exists in the catalog
    When I click the delete button for "Product to Delete"
    And I confirm the deletion
    Then I should see a success message
    And the product "Product to Delete" should be removed from the catalog
    And the products list should refresh

  # Edge Cases
  Scenario: Cancel product creation
    When I click on the "Add Product" button
    And I fill in some product information
    And I click the "Cancel" button
    Then the modal should close
    And no new product should be created
    And the form data should be cleared

  Scenario: Cancel product edit
    Given a product "Existing Product" exists
    When I click the edit button for the product
    And I modify the product information
    And I click the "Cancel" button
    Then the modal should close
    And the product should not be updated
    And the original data should be preserved

  Scenario: Close modal using X button
    When I click on the "Add Product" button
    And I click the close (×) button
    Then the modal should close
    And the form should be reset

  Scenario: Close modal by clicking outside
    When I click on the "Add Product" button
    And I click outside the modal on the backdrop
    Then the modal should close
    And the form should be reset

  Scenario: Create product with maximum length values
    When I create a product with:
      | field       | value                                                                  |
      | name        | Very long product name that tests the maximum character limit allowed  |
      | description | Extremely detailed product description with comprehensive information about features, benefits, specifications, warranty, and usage instructions that spans multiple lines |
      | price       | 999999.99                                                              |
    Then the product should be created successfully
    And all field values should be preserved

  Scenario: Create product with minimum valid price
    When I create a product with:
      | field | value           |
      | name  | Cheap Item      |
      | price | 0.01            |
    Then the product should be created successfully
    And the price should display as "$0.01"

  # Error Scenarios
  Scenario: Submit product form without required name
    When I click on the "Add Product" button
    And I fill in:
      | field       | value        |
      | description | Description  |
      | price       | 50.00        |
    And I leave the name field empty
    And I attempt to submit the form
    Then I should see a validation error for the name field
    And the form should not be submitted
    And the modal should remain open

  Scenario: Submit product with invalid price
    When I click on the "Add Product" button
    And I fill in the name with "Test Product"
    And I enter "invalid" in the price field
    Then the price field should show a validation error
    Or the form should prevent non-numeric input

  Scenario: Submit product with negative price
    When I click on the "Add Product" button
    And I fill in the name with "Test Product"
    And I enter "-50" in the price field
    Then the form should show a validation error
    Or the form should prevent negative values

  Scenario: Handle API error during product creation
    Given the API server is experiencing errors
    When I attempt to create a new product
    And I submit the form
    Then I should see an error message
    And the message should indicate the product could not be created
    And the modal should remain open
    And the form data should be preserved

  Scenario: Handle API error during product update
    Given a product exists in the catalog
    And the API server is experiencing errors
    When I attempt to edit the product
    And I submit the updated form
    Then I should see an error message
    And the message should indicate the product could not be updated
    And the original product data should be preserved

  Scenario: Handle API error during product deletion
    Given a product exists in the catalog
    And the API server is experiencing errors
    When I attempt to delete the product
    Then I should see an error message
    And the message should indicate the product could not be deleted
    And the product should remain in the catalog

  Scenario: Attempt to edit non-existent product
    When I attempt to edit a product that no longer exists
    Then I should see an error message
    And the modal should not open
    Or the modal should display an error state

  Scenario: Attempt to delete non-existent product
    When I attempt to delete a product that no longer exists
    Then I should see an error message
    And the product list should remain unchanged

  # Accessibility Scenarios
  Scenario: Navigate product modal using keyboard only
    When I open the product modal
    Then I should be able to tab through all form fields
    And I should be able to tab to the submit button
    And I should be able to tab to the cancel button
    And I should be able to press Escape to close the modal
    And focus should return to the trigger button after closing

  Scenario: Product modal has proper ARIA labels
    When I open the product modal
    Then the modal should have an appropriate ARIA role
    And the close button should have an ARIA label "Close modal"
    And all form inputs should have associated labels
    And the submit button should have clear button text

  Scenario: Screen reader announces modal state
    When I open the product modal with a screen reader
    Then the screen reader should announce the modal has opened
    And the modal title should be announced
    And form field labels should be read when focused
    And validation errors should be announced
