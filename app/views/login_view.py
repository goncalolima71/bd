from flask import Blueprint, render_template, request, redirect, url_for
from flask_login import login_user
from models.user_model import User

# Create a Blueprint for login view
login_view = Blueprint('login_view', __name__)

# Define the route for the login view '/'
@login_view.route('/', methods=["GET", "POST"])
def login():
    if request.method == 'POST':
        # Check user credentials
        # If credentials are correct, log the user in
        user = User.get_user(value=request.form['email'], attr_type="email")
        if user and user.check_password(request.form['password']):
            login_user(user)
            # Redirect the user to the appropriate page after login
            next_page = request.args.get('next')
            return redirect(next_page or url_for('home_view.home', user_id=user.id, username=user.username)), 200
        else:
            return render_template('login.html', error="Invalid username or password"), 401
    else:
        return render_template('login.html'), 200

