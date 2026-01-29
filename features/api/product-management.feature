Feature: Product Management API
  As an API consumer
  I want to manage products through RESTful endpoints
  So that I can create, read, update, and delete product information

  Background:
    Given the API server is running on port 5000
    And the product store is initialized

  # Happy Path Scenarios
  Scenario: Create a new product with all fields
    When I send a POST request to "/products" with body:
      | field       | value                          |
      | name        | Premium Wireless Headphones    |
      | description | High-quality noise cancelling  |
      | price       | 299.99                         |
      | category    | Electronics                    |
    Then the response status code should be 201
    And the response should contain a product ID
    And the response should contain:
      | field       | value                          |
      | name        | Premium Wireless Headphones    |
      | description | High-quality noise cancelling  |
      | price       | 299.99                         |
      | category    | Electronics                    |

  Scenario: Create a product with only required fields
    When I send a POST request to "/products" with body:
      | field | value           |
      | name  | Simple Product  |
    Then the response status code should be 201
    And the response should contain:
      | field       | value           |
      | name        | Simple Product  |
      | description |                 |
      | price       | 0               |
      | category    | General         |

  Scenario: Get all products
    Given the following products exist:
      | name       | description      | price  | category    |
      | Product A  | Description A    | 10.00  | Category 1  |
      | Product B  | Description B    | 20.00  | Category 2  |
    When I send a GET request to "/products"
    Then the response status code should be 200
    And the response should be a list of 2 products
    And the response should contain product "Product A"
    And the response should contain product "Product B"

  Scenario: Get a specific product by ID
    Given a product exists with:
      | field       | value            |
      | name        | Test Product     |
      | description | Test Description |
      | price       | 50.00            |
      | category    | Test Category    |
    When I send a GET request to "/products/<product_id>"
    Then the response status code should be 200
    And the response should contain:
      | field       | value            |
      | name        | Test Product     |
      | description | Test Description |
      | price       | 50.00            |
      | category    | Test Category    |

  Scenario: Update an existing product
    Given a product exists with name "Original Product"
    When I send a PUT request to "/products/<product_id>" with body:
      | field       | value              |
      | name        | Updated Product    |
      | description | Updated Description|
      | price       | 99.99              |
      | category    | Updated Category   |
    Then the response status code should be 200
    And the response should contain:
      | field       | value              |
      | name        | Updated Product    |
      | description | Updated Description|
      | price       | 99.99              |
      | category    | Updated Category   |

  Scenario: Delete an existing product
    Given a product exists with name "Product to Delete"
    When I send a DELETE request to "/products/<product_id>"
    Then the response status code should be 204
    And the response body should be empty

  # Edge Cases
  Scenario: Get products when product store is empty
    Given the product store is empty
    When I send a GET request to "/products"
    Then the response status code should be 200
    And the response should be an empty list

  Scenario Outline: Create products with boundary values
    When I send a POST request to "/products" with body:
      | field       | value              |
      | name        | <product_name>     |
      | description | <description>      |
      | price       | <price>            |
      | category    | <category>         |
    Then the response status code should be 201
    And the response should contain name "<product_name>"

    Examples:
      | product_name                  | description  | price    | category        |
      | A                             |              | 0        | General         |
      | Product with very long name that exceeds normal length expectations | Long desc | 0.01 | Test |
      | Special Chars !@#$%           | Test         | 999999.99| Special         |

  # Error Scenarios
  Scenario: Create a product without required name field
    When I send a POST request to "/products" with body:
      | field       | value      |
      | description | No name    |
      | price       | 10.00      |
    Then the response status code should be 400

  Scenario: Create a product with empty request body
    When I send a POST request to "/products" with an empty body
    Then the response status code should be 400

  Scenario: Get a non-existent product
    When I send a GET request to "/products/non-existent-id"
    Then the response status code should be 404

  Scenario: Update a non-existent product
    When I send a PUT request to "/products/non-existent-id" with body:
      | field | value         |
      | name  | Updated Name  |
    Then the response status code should be 404

  Scenario: Update a product without required name field
    Given a product exists with name "Existing Product"
    When I send a PUT request to "/products/<product_id>" with body:
      | field       | value          |
      | description | Missing name   |
    Then the response status code should be 400

  Scenario: Update a product with empty request body
    Given a product exists with name "Existing Product"
    When I send a PUT request to "/products/<product_id>" with an empty body
    Then the response status code should be 400

  Scenario: Delete a non-existent product
    When I send a DELETE request to "/products/non-existent-id"
    Then the response status code should be 404
