from flask import Flask, render_template, request, redirect, url_for, send_file
import boto3
from io import BytesIO

app = Flask(__name__)

# Correct MinIO connection settings
S3_ENDPOINT = "http://minio:9000"
S3_BUCKET = "uploads"
S3_ACCESS = "minioadmin"
S3_SECRET = "minioadmin"

s3 = boto3.client(
    "s3",
    endpoint_url=S3_ENDPOINT,
    aws_access_key_id=S3_ACCESS,
    aws_secret_access_key=S3_SECRET
)

@app.route("/")
def home():
    return redirect(url_for("gallery"))

@app.route("/upload", methods=["GET", "POST"])
def upload():
    if request.method == "POST":
        file = request.files["file"]
        if file:
            s3.upload_fileobj(file, S3_BUCKET, file.filename)
            return redirect(url_for("gallery"))
    return render_template("upload.html")

@app.route("/gallery")
def gallery():
    objects = s3.list_objects_v2(Bucket=S3_BUCKET).get("Contents", [])
    return render_template("gallery.html", objects=objects)

@app.route("/download/<filename>")
def download(filename):
    obj = s3.get_object(Bucket=S3_BUCKET, Key=filename)
    return send_file(BytesIO(obj['Body'].read()), as_attachment=True, download_name=filename)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
