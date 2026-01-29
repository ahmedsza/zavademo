# Gherkin Feature Files for Zava Application

This directory contains comprehensive Gherkin feature files documenting the behavior and requirements of the Zava e-commerce application.

## 📁 Directory Structure

```
features/
├── api/                          # API endpoint features
│   ├── product-management.feature    # Product CRUD operations
│   └── data-retrieval.feature       # Data fetching endpoints
├── ui/                           # User interface features
│   ├── homepage-navigation.feature  # Homepage and navigation
│   ├── product-catalog.feature      # Product browsing and filtering
│   ├── product-management.feature   # Product create/edit/delete UI
│   ├── contact-form.feature         # Contact form submission
│   └── newsletter-subscription.feature # Newsletter signup
├── utils/                        # Utility function features
│   ├── email-validation.feature     # Email format validation
│   ├── password-validation.feature  # Password strength and hashing
│   ├── file-operations.feature      # Logging and file handling
│   └── email-sending.feature        # SMTP email functionality
└── README.md                     # This file
```

## 🎯 Feature Coverage Overview

### API Features (api/)

#### Product Management API
- **Happy Path**: Create, read, update, delete products with full CRUD operations
- **Edge Cases**: Boundary values, empty stores, special characters
- **Error Scenarios**: Missing fields, non-existent resources, validation errors
- **Coverage**: ~20 scenarios covering all API endpoints

#### Data Retrieval API
- **Happy Path**: Successful data fetching from JSON files
- **Error Scenarios**: Missing files, invalid JSON, processing errors
- **Coverage**: 4 scenarios covering data retrieval patterns

### UI Features (ui/)

#### Homepage Navigation
- **Happy Path**: View hero section, navigate between pages, view featured products
- **Mobile**: Mobile menu toggle and responsive behavior
- **Edge Cases**: Empty product lists
- **Accessibility**: Keyboard navigation, screen reader support
- **Coverage**: 10 scenarios covering homepage interactions

#### Product Catalog Browsing
- **Happy Path**: View catalog, search products, filter by category
- **Edge Cases**: No results, empty catalog, special characters in search
- **Combined Filtering**: Search + category filters together
- **Error Scenarios**: API failures, network errors
- **Accessibility**: Keyboard navigation, ARIA labels
- **Coverage**: 15+ scenarios covering all browsing features

#### Product Management (UI Operations)
- **Happy Path**: Create, edit, delete products via modal UI
- **Modal Interactions**: Open, close, cancel operations
- **Edge Cases**: Maximum values, minimum values, form validation
- **Error Scenarios**: Missing required fields, API errors, invalid data
- **Accessibility**: Keyboard navigation, ARIA labels, focus management
- **Coverage**: 25+ scenarios covering complete product management workflow

#### Contact Form
- **Happy Path**: Submit contact form with valid data
- **Edge Cases**: Minimum required fields
- **Error Scenarios**: Missing fields, invalid email format
- **Accessibility**: Keyboard navigation, proper labels
- **Coverage**: 6 scenarios covering form submission

#### Newsletter Subscription
- **Happy Path**: Subscribe with valid email
- **Edge Cases**: Special characters in email
- **Error Scenarios**: Invalid email, missing email, various invalid formats
- **Accessibility**: Keyboard navigation, ARIA labels
- **Coverage**: 8 scenarios covering subscription flow

### Utility Features (utils/)

#### Email Validation
- **Happy Path**: 10+ valid email formats including subdomains, special characters
- **Edge Cases**: Maximum length, multiple subdomains, numbers
- **Error Scenarios**: 15+ invalid formats, empty strings, None values
- **Boundary Tests**: Minimum length, single character parts
- **Coverage**: 30+ scenarios covering comprehensive email validation

#### Password Validation & Hashing
- **Strength Validation**: All character type requirements (upper, lower, number, special)
- **Error Scenarios**: Too short, missing character types
- **Hashing**: SHA-256 hashing, deterministic results, uniqueness
- **Edge Cases**: Exact minimum length, very long passwords, unicode
- **Security**: Hash irreversibility, consistency
- **Coverage**: 20+ scenarios covering password security

#### File Operations & Logging
- **Logging**: Write messages, append logs, read logs
- **Unique Filenames**: Timestamp-based filename generation
- **Edge Cases**: Empty messages, long messages, special characters, multiple dots
- **Error Scenarios**: Permission denied, disk full, non-existent files
- **Security**: Safe message writing, no code injection
- **Coverage**: 25+ scenarios covering file operations

#### Email Sending (SMTP)
- **Happy Path**: Send text emails, HTML emails, multiple recipients, attachments
- **Configuration**: Environment variables, default ports
- **Edge Cases**: Empty body, long body, special characters, complex HTML
- **Error Scenarios**: Invalid config, unreachable server, invalid credentials
- **Security**: STARTTLS encryption, credential protection, injection prevention
- **Performance**: Timing, multiple sends
- **Coverage**: 30+ scenarios covering SMTP functionality

## 📊 Coverage Matrix Summary

| Feature Area | Happy Path | Edge Cases | Error Scenarios | Accessibility | Total Scenarios |
|--------------|------------|------------|-----------------|---------------|-----------------|
| Product Management API | ✓ | ✓ | ✓ | N/A | ~20 |
| Data Retrieval API | ✓ | - | ✓ | N/A | 4 |
| Homepage Navigation | ✓ | ✓ | - | ✓ | 10 |
| Product Catalog | ✓ | ✓ | ✓ | ✓ | 15+ |
| Product Management UI | ✓ | ✓ | ✓ | ✓ | 25+ |
| Contact Form | ✓ | ✓ | ✓ | ✓ | 6 |
| Newsletter | ✓ | ✓ | ✓ | ✓ | 8 |
| Email Validation | ✓ | ✓ | ✓ | N/A | 30+ |
| Password Validation | ✓ | ✓ | ✓ | N/A | 20+ |
| File Operations | ✓ | ✓ | ✓ | N/A | 25+ |
| Email Sending | ✓ | ✓ | ✓ | N/A | 30+ |
| **TOTAL** | **11/11** | **10/11** | **10/11** | **5/11** | **~190+** |

## 🎨 Gherkin Best Practices Used

### 1. **Business Language**
All scenarios are written in plain English without technical implementation details, making them readable by non-technical stakeholders.

### 2. **Given-When-Then Structure**
Each scenario follows the standard BDD structure:
- **Given**: Initial context and preconditions
- **When**: The action or event
- **Then**: Expected outcome and assertions

### 3. **Data Tables**
Complex data is represented using Gherkin tables for clarity:
```gherkin
When I send a POST request to "/products" with body:
  | field       | value                    |
  | name        | Premium Headphones       |
  | price       | 299.99                   |
```

### 4. **Scenario Outlines**
Parameterized tests use Scenario Outline for testing multiple inputs:
```gherkin
Scenario Outline: Validate various email formats
  When I validate the email "<email>"
  Then the result should be <result>
  
  Examples:
    | email              | result |
    | user@example.com   | True   |
    | invalid-email      | False  |
```

### 5. **Background**
Common preconditions are defined in Background sections to avoid repetition.

### 6. **Clear Scenario Names**
Each scenario has a descriptive name that clearly states what is being tested.

## 🧪 Testing Recommendations

### Automation Framework
These Gherkin files are designed to be implemented using:
- **Pytest-BDD** or **Behave** for Python-based testing
- **Playwright** or **Selenium** for UI automation
- **Requests** library for API testing

### Implementation Priority
1. **High Priority**: Product Management API, Product Catalog UI, Product Management UI
2. **Medium Priority**: Homepage Navigation, Email/Password Validation
3. **Low Priority**: Newsletter, Contact Form, File Operations

### Test Data Management
- Use factories or fixtures to create test data
- Implement proper cleanup after each scenario
- Consider using database transactions that can be rolled back
- For UI tests, seed the database before test runs

## 📝 Usage Guidelines

### For Developers
1. Read relevant feature files before implementing new functionality
2. Update feature files when requirements change
3. Use scenarios as acceptance criteria for user stories
4. Reference scenario numbers in pull requests

### For QA Engineers
1. Use feature files as test case documentation
2. Implement automated tests based on scenarios
3. Report coverage gaps as new scenarios
4. Link test results back to specific scenarios

### For Product Owners
1. Review feature files during sprint planning
2. Validate that scenarios match business requirements
3. Suggest additional edge cases or scenarios
4. Use feature files as living documentation

## 🔄 Maintenance

### Adding New Features
1. Create a new `.feature` file in the appropriate directory
2. Follow the existing structure and conventions
3. Include Background, Happy Path, Edge Cases, and Error Scenarios
4. Add accessibility scenarios for UI features
5. Update this README with coverage information

### Updating Existing Features
1. Add new scenarios to existing files
2. Update scenario descriptions if requirements change
3. Mark deprecated scenarios with tags like `@deprecated`
4. Maintain backward compatibility when possible

## 🏷️ Suggested Tags for Implementation

When implementing these scenarios, consider using these tags:
- `@api` - API endpoint tests
- `@ui` - User interface tests
- `@smoke` - Critical path tests
- `@regression` - Full regression suite
- `@accessibility` - Accessibility tests
- `@security` - Security-focused tests
- `@slow` - Tests that take longer to run
- `@wip` - Work in progress tests

Example:
```gherkin
@api @smoke
Scenario: Create a new product with all fields
  ...

@ui @accessibility
Scenario: Navigate using keyboard only
  ...
```

## 📚 Additional Resources

### Gherkin Documentation
- [Cucumber Gherkin Reference](https://cucumber.io/docs/gherkin/)
- [Gherkin Best Practices](https://cucumber.io/docs/bdd/better-gherkin/)

### Testing Frameworks
- [Pytest-BDD Documentation](https://pytest-bdd.readthedocs.io/)
- [Behave Documentation](https://behave.readthedocs.io/)
- [Playwright Python](https://playwright.dev/python/)

### BDD Resources
- [Behavior-Driven Development Overview](https://cucumber.io/docs/bdd/)
- [Writing Better User Stories](https://cucumber.io/blog/bdd/user-stories-are-not-the-same-as-features/)

## 🤝 Contributing

When adding or updating feature files:
1. Follow the existing structure and naming conventions
2. Use clear, business-friendly language
3. Include all four categories: Happy Path, Edge Cases, Error Scenarios, Accessibility
4. Add examples and data tables for clarity
5. Update this README with your changes
6. Consider the perspective of all stakeholders (developers, QA, product owners)

---

**Last Updated**: January 2026  
**Total Scenarios**: ~190+  
**Feature Files**: 11  
**Coverage**: Comprehensive (API, UI, Utils)
