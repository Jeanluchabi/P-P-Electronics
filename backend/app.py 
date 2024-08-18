from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

# Database setup
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///yourdatabase.db'
db = SQLAlchemy(app)

# Define the Product model
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    price = db.Column(db.Float, nullable=False)
    carts = db.relationship('Cart', backref='product', lazy=True)
    orders = db.relationship('Order', backref='product', lazy=True)

# Define the Cart model
class Cart(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=1)
    product = db.relationship('Product', backref=db.backref('carts', lazy=True))

# Define the Order model
class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    product = db.relationship('Product', backref=db.backref('orders', lazy=True))

# Define the User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

# Routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/products')
def products():
    all_products = Product.query.all()
    return render_template('products.html', products=all_products)

@app.route('/orders')
def orders():
    return render_template('orders.html')

@app.route('/account')
def account():
    return render_template('account.html')

@app.route('/search', methods=['POST'])
def search():
    query = request.form.get('query')
    # Handle the search logic here
    print(f"User searched for: {query}")
    return redirect(url_for('index'))  # Redirect to homepage after search

@app.route('/add_to_cart/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    product = Product.query.get_or_404(product_id)
    cart_item = Cart.query.filter_by(product_id=product_id).first()

    if cart_item:
        cart_item.quantity += 1
    else:
        cart_item = Cart(product_id=product_id, quantity=1)
        db.session.add(cart_item)

    db.session.commit()
    return redirect(url_for('products'))

@app.route('/order/<int:product_id>', methods=['POST'])
def order(product_id):
    product = Product.query.get_or_404(product_id)
    quantity = request.form.get('quantity', type=int)
    order = Order(product_id=product_id, quantity=quantity)
    db.session.add(order)
    db.session.commit()
    return redirect(url_for('orders'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User(username=username)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        if user and user.check_password(password):
            # Log the user in (session management needed)
            return redirect(url_for('index'))
        else:
            return 'Invalid credentials'
    return render_template('login.html')

if __name__ == '__main__':
    db.create_all()  # Create database tables if they don't exist

    # Add sample products if the database is empty
    if Product.query.count() == 0:
        sample_products = [
            Product(name="Apple iPhone 15 Pro Max", price=1299.00),
            Product(name="Samsung Galaxy S24 Ultra", price=1199.00),
            Product(name="Google Pixel 9 Pro XL", price=1099.00)
        ]
        db.session.bulk_save_objects(sample_products)
        db.session.commit()
        print("Sample products added to the database.")

    app.run(debug=True)


