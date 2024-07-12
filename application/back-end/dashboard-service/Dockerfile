FROM python:3.12-slim

RUN apt-get update && apt-get install -y git gcc g++
WORKDIR /app
COPY . .
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python" , "-u", "app.py"]