from flask import Flask, render_template, request, redirect, url_for
import boto3
import os

app = Flask(__name__)

# Load secret key from environment
app.secret_key = os.getenv("FLASK_SECRET_KEY", "fallback-secret")

# Load MinIO config from environment
MINIO_ENDPOINT = os.getenv("MINIO_ENDPOINT", "http://localhost:9000")
MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY", "minioadmin")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY", "minioadmin")
BUCKET = os.getenv("MINIO_BUCKET", "uploads")

# Create MinIO client
S3 = boto3.client(
    "s3",
    endpoint_url=MINIO_ENDPOINT,
    aws_access_key_id=MINIO_ACCESS_KEY,
    aws_secret_access_key=MINIO_SECRET_KEY,
    region_name="us-east-1"
)

@app.route("/")
def index():
    return render_template("gallery.html")

@app.route("/upload", methods=["GET", "POST"])
def upload():
    if request.method == "POST":
        file = request.files.get("file")
        if file:
            S3.upload_fileobj(file, BUCKET, file.filename)
            return redirect(url_for("gallery"))
    return render_template("upload.html")

@app.route("/gallery")
def gallery():
    objects = S3.list_objects_v2(Bucket=BUCKET).get("Contents", [])
    return render_template("gallery.html", objects=objects)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)
