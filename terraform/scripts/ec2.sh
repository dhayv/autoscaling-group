#!/bin/bash
cloud-init status --wait

apt update -y
apt upgrade -y
sudo apt install nginx -y

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

sudo service nginx enable
sudo service nginx restart