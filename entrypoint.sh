#!/bin/bash
# entrypoint.sh

# Exit on any error
set -e

# Apply database migrations
echo "Applying database migrations..."
python3 manage.py migrate

# Check if the database is empty and populate it if necessary
# This is a simplistic check, adjust the query to fit your application's logic
echo "Checking if the database is empty..."
if python3 manage.py shell -c "from django.contrib.auth.models import User; exit(0 if User.objects.exists() else 1)"; then
    echo "Database already populated."
else
    echo "Populating the database with example data..."
    python3 manage.py populatedb

    # Only attempt to create superuser if it doesn't exist.
    echo "Creating superuser..."
    python3 manage.py createsuperuser --noinput || true
fi

# Start the application
exec gunicorn --bind ":8000" --workers 4 --worker-class "saleor.asgi.gunicorn_worker.UvicornWorker" "saleor.asgi:application"
