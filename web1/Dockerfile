FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# FORCE COPY USING ABSOLUTE PATH
COPY ./app /app/app

EXPOSE 5000

CMD ["python", "app/app.py"]
