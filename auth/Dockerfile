FROM python:3.11-slim
RUN pip install flask --timeout 100
COPY app.py app.py
CMD [ "python", "app.py" ]