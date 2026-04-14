# Terraform VPC Project – Setup & Installation Guide

## 🏗️ Project Architecture Diagram

```
                          ┌─────────────────────────────────────────┐
                          │              AWS Cloud                  │
                          │                                         │
                          │   ┌─────────────────────────────────┐   │
                          │   │            VPC                  │   │
                          │   │                                 │   │
                          │   │  ┌──────────┐  ┌──────────┐   │   │
                          │   │  │ Public   │  │ Private  │   │   │
                          │   │  │ Subnet   │  │ Subnet   │   │   │
                          │   │  │          │  │          │   │   │
                          │   │  │ Jenkins  │  │   App    │   │   │
                          │   │  │ Server   │  │ Servers  │   │   │
                          │   │  └────┬─────┘  └──────────┘   │   │
                          │   │       │                         │   │
                          │   │  ┌────▼─────┐                  │   │
                          │   │  │ Internet │                  │   │
                          │   │  │ Gateway  │                  │   │
                          │   └──└──────────┘──────────────────┘   │
                          └─────────────────────────────────────────┘
                                        │
                          ┌─────────────▼─────────────┐
                          │      Terraform (IaC)       │
                          │   Provision Infrastructure │
                          └─────────────┬──────────────┘
                                        │
                          ┌─────────────▼─────────────┐
                          │      Jenkins (CI/CD)        │
                          │   Automate Deployments     │
                          └────────────────────────────┘
```

---

## 📋 Prerequisites

| Tool | Purpose |
|---|---|
| **Terraform** | Infrastructure as Code – provision AWS VPC |
| **Jenkins** | CI/CD pipeline automation |
| **Java (JDK 11)** | Required for Jenkins |
| **Git / Maven / Tree** | Dev & build utilities |
| **SSH Key Pair** | Secure server access |

---

## 🔑 SSH Key Setup (All Servers)

```bash
ssh-keygen
```

---

## 🟦 Terraform Installation (Ubuntu)

### Step 1 – Update System
```bash
apt update
```

### Step 2 – Download Terraform
```bash
wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
```

### Step 3 – Install & Extract
```bash
apt install unzip -y
unzip terraform_0.14.7_linux_amd64.zip
```

### Step 4 – Move to System PATH
```bash
mv terraform /usr/local/bin/
```

### Step 5 – Verify Installation
```bash
terraform -v
```

---

## 🟧 Jenkins Installation – Ubuntu

### Step 1 – Install Java
```bash
apt install openjdk-11-jre-headless -y
```

### Step 2 – Install Utilities
```bash
apt install git maven tree -y
apt update -y
```

### Step 3 – Add Jenkins Repository Key
```bash
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```

### Step 4 – Add Jenkins Repo
```bash
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

### Step 5 – Install Jenkins
```bash
apt update
apt install jenkins -y
```

### Step 6 – Start Jenkins
```bash
systemctl start jenkins
systemctl enable jenkins
```

### Step 7 – Get Initial Admin Password
```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

> 🌐 Access Jenkins UI at: `http://<server-ip>:8080`

---

## 🟥 Jenkins Installation – Amazon Linux

### Step 1 – Install Java
```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

### Step 2 – Add Jenkins Repo
```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  http://pkg.jenkins-ci.org/redhat/jenkins.repo
```

### Step 3 – Import GPG Keys
```bash
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

### Step 4 – Install Jenkins
```bash
sudo yum install jenkins -y
```

### Step 5 – Enable & Start Jenkins
```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

### Step 6 – Get Initial Admin Password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

> 🌐 Access Jenkins UI at: `http://<server-ip>:8080`

---

## 📊 Installation Comparison

| Step | Ubuntu | Amazon Linux |
|---|---|---|
| Java | `openjdk-11-jre-headless` | `amazon-linux-extras java-openjdk11` |
| Package Manager | `apt` | `yum` |
| Repo Key | `curl` + keyring | `rpm --import` |
| Start Jenkins | `systemctl start jenkins` | `systemctl start jenkins` |
| Admin Password | `/var/lib/jenkins/secrets/initialAdminPassword` | Same path |

---

## 📂 Key File & Port Reference

| Item | Location / Value |
|---|---|
| Jenkins Admin Password | `/var/lib/jenkins/secrets/initialAdminPassword` |
| Jenkins Default Port | `8080` |
| Terraform Binary | `/usr/local/bin/terraform` |
| SSH Private Key | `~/.ssh/id_rsa` |
| SSH Public Key | `~/.ssh/id_rsa.pub` |

---

## 🔄 Project Workflow

```
Developer  →  Git Push  →  Jenkins Pipeline  →  Terraform Apply  →  AWS VPC
   │                            │                      │
   │                      Build & Test           Provision:
   │                            │                 - VPC
   └────────────────────────────┘                 - Subnets
                                                  - Security Groups
                                                  - EC2 Instances
                                                  - Internet Gateway
```
