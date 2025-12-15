from flask import Flask

app = Flask(__name__)

@app.route("/home")
def home():
    return """
    <h1>Frontend App</h1>
    <p>This is the frontend service</p>
    <a href="/api">Call Backend</a>
    <a href="/auth">Call Auth</a>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7000)