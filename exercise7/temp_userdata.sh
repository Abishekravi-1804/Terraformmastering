# Create a much smaller userdata.sh
cat > userdata.sh << 'EOF'
#!/bin/bash
# userdata.sh - Minimal EC2 instance initialization script

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting Day 7 State Management Demo instance initialization..."
echo "Instance Number: ${instance_number}"
echo "Project Name: ${project_name}"
echo "Environment: ${environment}"

# Update system
yum update -y

# Install required packages
yum install -y httpd aws-cli jq

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Create simple web page
cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Day 7 - Terraform State Management</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        .card { background: #f5f5f5; padding: 20px; margin: 10px 0; border-radius: 8px; }
        h1 { color: #2c3e50; text-align: center; }
    </style>
</head>
<body>
    <h1>🚀 Day 7: Terraform State Management</h1>
    <div class="card">
        <h3>Instance #${instance_number}</h3>
        <p><strong>Project:</strong> ${project_name}</p>
        <p><strong>Environment:</strong> ${environment}</p>
        <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
        <p><strong>Public IP:</strong> $PUBLIC_IP</p>
    </div>
    <div class="card">
        <h3>🎯 State Management Features</h3>
        <ul>
            <li>Remote State Storage in S3</li>
            <li>State Locking with DynamoDB</li>
            <li>Version Control & Recovery</li>
            <li>Team Collaboration Ready</li>
        </ul>
    </div>
    <p><em>Deployed: $(date)</em></p>
</body>
</html>
HTML

# Create health check endpoint
cat > /var/www/html/health << EOF
{
  "status": "healthy",
  "instance_id": "$INSTANCE_ID",
  "project": "${project_name}",
  "instance_number": ${instance_number},
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

echo "Day 7 State Management Demo instance initialization completed!"
EOF

chmod +x userdata.sh
