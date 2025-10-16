import os
import requests
from flask import Flask, render_template, request, redirect, url_for, flash

GITHUB_OWNER   = os.getenv("GITHUB_OWNER", "saditha93")
GITHUB_REPO    = os.getenv("GITHUB_REPO",  "infra-apis-test")
WORKFLOW_FILE  = os.getenv("WORKFLOW_FILE","deploy_k8s.yml")
GITHUB_TOKEN   = os.getenv("GITHUB_TOKEN")  # GitHub App installation token or PAT

CLIENTS = [
    {"key": "neo-retail", "label": "Neo Retail"},
    {"key": "bonz", "label": "Bonz"},
]

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "change-me")

def dispatch_workflow(client_key: str, image_tag: str):
    url = f"https://api.github.com/repos/{GITHUB_OWNER}/{GITHUB_REPO}/actions/workflows/{WORKFLOW_FILE}/dispatches"
    payload = {
        "ref": "main",
        "inputs": { "client": client_key, "image_tag": image_tag }
    }
    r = requests.post(url, json=payload, headers={
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Accept": "application/vnd.github+json",
    })
    return r.status_code, r.text

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html", clients=CLIENTS)

@app.route("/deploy", methods=["POST"])
def deploy():
    client = request.form.get("client")
    image_tag = request.form.get("image_tag", "latest").strip() or "latest"
    code, text = dispatch_workflow(client, image_tag)
    if 200 <= code < 300:
        flash(f"Deploy requested for {client} (tag: {image_tag}). Check Actions.", "success")
    else:
        flash(f"Failed to dispatch: {code} {text}", "error")
    return redirect(url_for("index"))

if __name__ == "__main__":
    app.run("0.0.0.0", 5000)
