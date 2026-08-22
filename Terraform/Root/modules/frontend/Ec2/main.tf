# frontend server creation

resource "aws_instance" "frontend" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids       = [var.security_group_id]
  associate_public_ip_address  = false

  user_data = <<-EOF
#!/bin/bash
set -euxo pipefail

# Update system
yum update -y

# Install required packages
yum install -y git nginx

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Clone application repository
cd /tmp
git clone https://github.com/Dheeraj2834/aws-ecomerce-Application-Multiple-services.git

# Copy frontend files
sudo cp -r * /usr/share/nginx/html/
sudo cp -r main/* /usr/share/nginx/html/

# Create custom Nginx configuration
cat <<NGINX > /etc/nginx/conf.d/google-store.conf
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location = /api {
        proxy_pass http://BACKEND_PRIVATE_IP:5000/api;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /api/ {
        proxy_pass http://BACKEND_PRIVATE_IP:5000/api/;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
NGINX

# Remove default Nginx configuration
sudo rm -f /etc/nginx/conf.d/default.conf

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

# Display status
sudo systemctl status nginx

EOF

  tags = {
    Name = "frontend-server"
  }
}