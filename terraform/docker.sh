#!/bin/bash

# Update and install Docker
apt-get update -y
apt-get install -y docker.io git

# Start and enable Docker
systemctl start docker
systemctl enable docker


# Optional: make Docker usable by ubuntu user
chown ubuntu:docker /var/run/docker.sock

# Clone the repo into ubuntu's home directory
sudo -u ubuntu git clone https://github.com/Vibhuti456/django-notes-app.git /home/ubuntu/django-notes-app

# Build and run as ubuntu to avoid root-permission mismatch
sudo -u ubuntu bash -c "
  cd /home/ubuntu/django-notes-app
  docker build -t notes-app .
  docker run -d -p 8000:8000 notes-app:latest
"
