from flask_login import LoginManager
from models.user_model import User

login_manager = LoginManager()

@login_manager.user_loader
def load_user(user_id):
    return User.get_user("user_id", user_id)
