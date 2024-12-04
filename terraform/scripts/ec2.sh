#!/bin/bash

# Wait for cloud-init
cloud-init status --wait

# Update and install nginx
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

# Create custom index page
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Auto Scaling Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .info { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Hello from Auto Scaling Group!</h1>
    <div class="info">
        <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
        <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
        <p>Running on Ubuntu</p>
    </div>
</body>
</html>
EOF

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Verify nginx is running
systemctl status nginx

# Add a final check
if curl -s localhost > /dev/null; then
    echo "Nginx is responding correctly"
else
    echo "Nginx is not responding"
fi