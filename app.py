from flask import Flask, jsonify, request, abort, render_template
from flask_cors import CORS
from uuid import uuid4
import json

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# In-memory product store
data = {}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getdata', methods=['GET'])
def get_data():
    with open('sampledata.json', 'r') as file:
        data_content = json.load(file)
        users = data_content.get('user')
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

@app.route('/SubmitFeedback', methods=['POST'])
def submit_feedback():
    body = request.get_json()
    if not body or 'name' not in body or 'category' not in body or 'message' not in body:
        abort(400)
    
    # Log the feedback to the console
    print(f"Feedback received:")
    print(f"  Name: {body['name']}")
    print(f"  Category: {body['category']}")
    print(f"  Message: {body['message']}")
    
    return jsonify({'status': 'success', 'message': 'Feedback submitted successfully'}), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
