#!/bin/bash
set -e
set -x

# 1. Update package lists and upgrade installed packages
apt-get update -y
apt-get upgrade -y

# 2. Install Nginx
apt-get install nginx -y

# 3. Obtain IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

# 4. Fetch instance metadata using IMDSv2
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# 5. Create custom index.html with the retrieved metadata
cat > /var/www/html/index.html << EOF
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
        <p>Instance ID: $INSTANCE_ID</p>
        <p>Availability Zone: $AVAILABILITY_ZONE</p>
        <p>Running on Ubuntu</p>
    </div>
</body>
</html>
EOF

# 6. Restart Nginx to apply changes
systemctl restart nginx
