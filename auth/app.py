from flask import Flask
app = Flask(__name__)

@app.route("/auth")
def auth():
    return {"service": "auth", "status": "ok"}

app.run(host="0.0.0.0", port=4000)