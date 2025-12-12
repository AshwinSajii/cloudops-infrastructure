FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ app/

RUN echo "import os" >> app/app.py
RUN echo "@app.route('/who')\ndef who():\n    return 'Hello from ' + os.getenv('INSTANCE_NAME', 'UNKNOWN')" >> app/app.py

EXPOSE 5000
CMD ["python", "app/app.py"]
