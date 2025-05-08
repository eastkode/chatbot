FROM python:3.9-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Set environment variable at runtime
ENV OPENAI_API_KEY=${OPENAI_API_KEY}

CMD ["python", "app.py"]
