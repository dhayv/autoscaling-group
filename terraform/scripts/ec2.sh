#!/bin/bash

sudo apt update  -y
sudo apt upgrade  -y
# Wait for cloud-init
sudo cloud-init status --wait

sudo apt install nginx -y
# Update and install nginx

# Fetch instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create custom index page
sudo tee /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Auto Scaling Demo</title>
    <style>
        body > > > > > > { font-family: Arial, sans-serif; margin: 40px; }
        .info { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Hello from Auto Scaling Group!</h1>
    <div class="info">
        <p>Instance ID: $INSTANCE_ID </p>
        <p>Availability Zone: $AVAILABILITY_ZONE </p>
        <p>Running on Ubuntu</p>
    </div>
</body>
</html>
EOF



sudo systemctl restart nginx
