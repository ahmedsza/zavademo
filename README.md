# ZAVA Demo

[![Python](https://img.shields.io/badge/Python-3.13+-blue.svg)](https://www.python.org/downloads/)
[![Flask](https://img.shields.io/badge/Flask-3.x-green.svg)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](docs/CONTRIBUTING.md)

> A modern e-commerce backoffice management system for product catalog and inventory control.

ZAVA is a demonstration platform showcasing RESTful API design, single-page application architecture, and modern UI/UX principles. Built with Flask and vanilla JavaScript, it provides a clean interface for CRUD operations on product data.

![ZAVA Demo Screenshot](docs/images/zava-screenshot.png)

## ✨ Features

- 🛍️ **Product Management** - Complete CRUD operations for products with categories
- 🔍 **Search & Filter** - Real-time search and category-based filtering
- 😄 **Dad Jokes** - Integrated joke API with 30-second caching
- 📧 **Email Integration** - SMTP email service via Azure Communication Services
- 📱 **Responsive Design** - Mobile-first UI with Tailwind CSS
- 🎨 **Modern Interface** - Minimalist black-and-white design aesthetic

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [Testing](#-testing)
- [Known Limitations](#-known-limitations)
- [Contributing](#-contributing)
- [License](#-license)

## 🚀 Quick Start

Get up and running in 3 simple steps:

```bash
# 1. Navigate to project directory
cd ZavaDemo

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run the application
python app.py
```

Open your browser to [http://localhost:5000](http://localhost:5000) and start managing products!

## 📦 Installation

### Prerequisites

- Python 3.13 or higher
- pip (Python package manager)
- Modern web browser (Chrome, Firefox, Edge, Safari)

### Step-by-Step Setup

1. **Clone the repository** (or navigate to the project directory):
   ```bash
   cd D:\aipres\Demos\ZavaDemo
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```
   
   This installs:
   - Flask - Web framework
   - flask-cors - Cross-Origin Resource Sharing support
   - SQLAlchemy - Database ORM
   - pytest - Testing framework
   - selenium - Browser automation
   - requests - HTTP client library
   - mkdocs-material - Documentation

3. **Configure email (optional):**
   
   Create a `.env` file in the project root for email functionality:
   ```env
   SMTP_HOST=smtp.azurecomm.net
   SMTP_PORT=587
   SMTP_USERNAME=your_username
   SMTP_PASSWORD=your_password
   FROM_EMAIL=sender@example.com
   FROM_NAME=ZAVA Team
   ```

4. **Start the development server:**
   ```bash
   python app.py
   ```
   
   The server will start at `http://127.0.0.1:5000` with debug mode enabled.

## 🎯 Usage

### Managing Products

**Create a Product:**
1. Navigate to the Products page
2. Click "+ ADD PRODUCT"
3. Fill in product details (name is required)
4. Click "SAVE PRODUCT"

**Edit a Product:**
1. Click the "Edit" button on any product row
2. Modify the fields in the modal
3. Click "UPDATE PRODUCT"

**Delete a Product:**
1. Click the "Delete" button on any product row
2. Confirm the deletion in the prompt

**Search and Filter:**
- Use the search bar to find products by name or description
- Select a category from the dropdown to filter results
- Combine both for precise filtering

### Viewing Dad Jokes

1. Navigate to the "ABOUT" page
2. A dad joke will automatically load
3. Click "GET NEW JOKE" to refresh (cached for 30 seconds)

### Email Configuration

To use the email functionality:

1. Configure your `.env` file with SMTP credentials
2. Import the `SMTPEmailSender` class:
   ```python
   from send_email import SMTPEmailSender
   
   sender = SMTPEmailSender()
   sender.send_email(
       to_email="recipient@example.com",
       body="Your message here",
       html_body="<h1>HTML content</h1>"
   )
   ```

## 📚 API Documentation

### Product Endpoints

#### List All Products
```http
GET /products
```
Returns an array of all products.

**Response:** `200 OK`
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "category": "Electronics"
  }
]
```

#### Get Single Product
```http
GET /products/{id}
```

**Response:** `200 OK` or `404 Not Found`

#### Create Product
```http
POST /products
Content-Type: application/json

{
  "name": "Laptop",
  "description": "High-performance laptop",
  "price": 999.99,
  "category": "Electronics"
}
```

**Response:** `201 Created`

#### Update Product
```http
PUT /products/{id}
Content-Type: application/json

{
  "name": "Updated Name",
  "description": "Updated description",
  "price": 899.99,
  "category": "Electronics"
}
```

**Response:** `200 OK` or `404 Not Found`

#### Delete Product
```http
DELETE /products/{id}
```

**Response:** `204 No Content` or `404 Not Found`

### Other Endpoints

#### Get Dad Joke
```http
GET /dadjoke
```

Returns a dad joke from [icanhazdadjoke.com](https://icanhazdadjoke.com/) with 30-second caching.

**Response:** `200 OK`
```json
{
  "joke": "Why don't scientists trust atoms? Because they make up everything!",
  "cached": true
}
```

For complete API documentation, see [zavacode.md](zavacode.md#api-endpoints).

## 📁 Project Structure

```
ZavaDemo/
├── app.py                 # Flask application and API routes
├── utils.py              # Utility functions (validation, processing)
├── send_email.py         # SMTP email sender
├── test_app.py           # Application unit tests
├── test_utils.py         # Utility function tests
├── requirements.txt      # Python dependencies
├── sampledata.json       # Sample user data
├── sample_data.csv       # Sample sales data
├── demo.py               # Code demonstration file
├── LICENSE               # MIT License
├── zavacode.md          # Complete codebase documentation
└── templates/
    └── index.html        # Single-page application UI
```

### Key Components

- **app.py** - Main Flask server with all HTTP route handlers
- **templates/index.html** - Frontend SPA with Tailwind CSS styling
- **utils.py** - Email validation, password hashing, data processing
- **send_email.py** - Azure Communication Services email integration

For detailed component documentation, see [zavacode.md](zavacode.md#backend-components).

## 🛠️ Development

### Running in Development Mode

The application runs with Flask's debug mode enabled by default:

```bash
python app.py
```

This provides:
- ✅ Auto-reload on file changes
- ✅ Detailed error pages
- ✅ Interactive debugger

**⚠️ Warning:** Never use debug mode in production!

### Code Style

Follow these conventions:
- PEP 8 for Python code
- 4-space indentation
- Descriptive variable names
- Type hints where appropriate

Check code style:
```bash
flake8 app.py utils.py send_email.py
```

### Database Note

**Important:** This demo uses in-memory storage. All product data is lost when the server restarts. For production use, implement a persistent database solution (SQLite, PostgreSQL, MySQL).

## 🧪 Testing

### Running Tests

Run all tests:
```bash
pytest
```

Run specific test file:
```bash
pytest test_utils.py -v
```

Generate coverage report:
```bash
pytest --cov=. --cov-report=html
```

View coverage report:
```bash
open htmlcov/index.html  # macOS
start htmlcov/index.html # Windows
```

### Test Coverage

Current test coverage:
- ✅ Email validation (32 test cases)
- ⚠️ Application routes (not implemented)
- ⚠️ Error handling (not implemented)

### Manual Testing

Use the manual testing checklist in [zavacode.md](zavacode.md#testing) to verify:
- Product CRUD operations
- Search and filter functionality
- Dad joke caching behavior
- UI responsiveness

## ⚠️ Known Limitations

### Critical Issues

1. **Non-Persistent Storage** 🔴
   - Products stored in memory only
   - All data lost on server restart
   - Solution: Implement database persistence

2. **Hardcoded Credentials** 🔴
   - SMTP credentials in source code (send_email.py)
   - Security vulnerability
   - Solution: Use environment variables exclusively

3. **No Authentication** 🔴
   - Anyone can access and modify data
   - No user management
   - Solution: Implement authentication/authorization

### Performance Limitations

- No pagination (all products loaded at once)
- Client-side filtering (inefficient with large datasets)
- No database indexing
- No caching strategy for API responses

### Missing Features

- User authentication and authorization
- Data persistence (database)
- Server-side input validation
- Rate limiting
- API versioning
- Image upload for products
- Bulk operations
- Export functionality (CSV, Excel)

For a complete list of issues and recommendations, see [zavacode.md](zavacode.md#known-issues--limitations).

## 🤝 Contributing

We welcome contributions! Whether it's:

- 🐛 Bug reports
- ✨ Feature requests
- 📝 Documentation improvements
- 🔧 Code contributions

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Write clear commit messages
- Add tests for new features
- Update documentation as needed
- Follow the existing code style
- Ensure all tests pass before submitting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Additional Resources

- [Complete Codebase Documentation](zavacode.md) - Detailed technical documentation
- [API Reference](zavacode.md#api-endpoints) - Full API specification
- [Architecture Overview](zavacode.md#architecture) - System design and components
- [Security Considerations](zavacode.md#security-considerations) - Security guidelines
- [Best Practices](zavacode.md#best-practices-for-production) - Production recommendations

## 📞 Support

For questions or issues:

1. Check the [zavacode.md](zavacode.md) documentation
2. Open an issue on GitHub
3. Contact the maintainers

---

**Built with ❤️ using Flask and Tailwind CSS**

*Last updated: January 29, 2026*
