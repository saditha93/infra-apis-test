from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.get("/health")
def health():
    return {"status": "ok", "service": "api1"}

@app.get("/hello")
def hello():
    name = os.getenv("SERVICE_NAME", "api1")
    return jsonify(message=f"Hello from {name}!")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8001)