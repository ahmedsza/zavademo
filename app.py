
from flask import Flask, jsonify, request, abort, render_template
from flask_cors import CORS
from uuid import uuid4
import json
import requests
import csv
from datetime import datetime, timedelta

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# In-memory product store
data = {}

# Dad joke cache
dad_joke_cache = {
    'joke': None,
    'timestamp': None
}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getdata', methods=['GET'])
def get_data():
    with open('sampledata.json', 'r') as file:
        data_content = json.load(file)
        users = data_content.get('users')
        # Intentionally cause a complex error: trying to iterate over a non-iterable
        # and perform operations that will fail
        for user in users:
            result = user['name'].split()[0] / len(user['email'])  # TypeError: unsupported operand type(s)
            complex_calc = int(user['address']['zipcode']) + user['phone']  # TypeError if phone is string
            nested_data = data_content['nonexistent_key']['nested']['deep']  # KeyError
        return jsonify(users), 200

@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(list(data.values())), 200

@app.route('/products/<product_id>', methods=['GET'])
def get_product(product_id):
    product = data.get(product_id)
    if not product:
        abort(404)
    return jsonify(product), 200

@app.route('/products', methods=['POST'])
def create_product():
    body = request.get_json()
    if not body or 'name' not in body:
        abort(400)
    product_id = str(uuid4())
    product = {
        'id': product_id, 
        'name': body['name'], 
        'description': body.get('description', ''),
        'price': body.get('price', 0),
        'category': body.get('category', 'General')
    }
    data[product_id] = product
    return jsonify(product), 201

@app.route('/products/<product_id>', methods=['PUT'])
def update_product(product_id):
    if product_id not in data:
        abort(404)
    body = request.get_json()
    if not body or 'name' not in body:
        abort(400)
    data[product_id].update({
        'name': body['name'], 
        'description': body.get('description', ''),
        'price': body.get('price', 0),
        'category': body.get('category', 'General')
    })
    return jsonify(data[product_id]), 200

@app.route('/products/<product_id>', methods=['DELETE'])
def delete_product(product_id):
    if product_id not in data:
        abort(404)
    del data[product_id]
    return '', 204

@app.route('/dadjoke', methods=['GET'])
def get_dad_joke():
    """
    Fetches a dad joke from an external API and caches it for 30 seconds.
    Returns the cached joke if it's still valid.
    """
    global dad_joke_cache
    
    # Check if cache is still valid (within 30 seconds)
    if (dad_joke_cache['joke'] is not None and 
        dad_joke_cache['timestamp'] is not None and 
        datetime.now() - dad_joke_cache['timestamp'] < timedelta(seconds=30)):
        return jsonify({
            'joke': dad_joke_cache['joke'],
            'cached': True
        }), 200
    
    # Fetch new joke from API
    try:
        response = requests.get(
            'https://icanhazdadjoke.com/',
            headers={'Accept': 'application/json'},
            timeout=5
        )
        response.raise_for_status()
        joke_data = response.json()
        
        # Update cache
        dad_joke_cache['joke'] = joke_data['joke']
        dad_joke_cache['timestamp'] = datetime.now()
        
        return jsonify({
            'joke': joke_data['joke'],
            'cached': False
        }), 200
    except Exception as e:
        # Return a fallback joke if API fails
        return jsonify({
            'joke': "Why don't scientists trust atoms? Because they make up everything!",
            'error': str(e),
            'cached': False
        }), 200

@app.route('/api/sales-data', methods=['GET'])
def get_sales_data():
    """
    Reads sales data from sample_data.csv and returns it as JSON.
    Returns all sales records for dashboard visualization and filtering.
    """
    try:
        sales_data = []
        with open('sample_data.csv', 'r', encoding='utf-8') as file:
            csv_reader = csv.DictReader(file)
            for row in csv_reader:
                sales_data.append({
                    'year': row['Year'],
                    'quarter': row['Quarter'],
                    'category': row['Category'],
                    'amount': float(row['Amount']),
                    'location': row['Location']
                })
        return jsonify(sales_data), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
