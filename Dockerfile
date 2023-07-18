FROM python:3.9-alpine

#working directory in the container
WORKDIR /app

# Install dependencies
RUN apk update \
    && apk add --no-cache \
        gcc \
        musl-dev \
        python3-dev \
        postgresql-dev

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Copy the application code to the container
COPY . /app

# Create and activate a virtual environment
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"
RUN source venv/bin/activate

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run database migrations
RUN python manage.py migrate        

# Expose the application port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]