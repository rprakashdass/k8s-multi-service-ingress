import os
from flask import Flask
BACKEND_BASE_URL = os.getenv("BACKEND_BASE_URL")

app = Flask(__name__)

@app.route("/")
def home():
    return  f"""
            <h1>Frontend App</h1>
            <p>This is the frontend service</p>
            <a href="{BACKEND_BASE_URL}/api">Call Backend</a>
            <a href="{BACKEND_BASE_URL}/auth">Call Auth</a>
            """


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)