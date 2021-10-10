yum update -y
amazon-linux-extras install epel -y
yum install java-1.8.0 -y
yum remove java-1.7.0-openjdk
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade
yum remove java-1.8.0
systemctl daemon-reload
yum upgrade -y
yum install jenkins git -y
systemctl start jenkins