# 🏗️ jenkins-terraform

> Automate AWS infrastructure provisioning using **Terraform** managed through a **Jenkins** CI/CD pipeline — fully installed on Amazon Linux.

---

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Developer / Engineer                         │
│                                                                     │
│         Write Terraform (.tf files)  →  Push to Git Repo           │
└──────────────────────────┬──────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Jenkins Server                                 │
│                    (Amazon Linux EC2)                               │
│                                                                     │
│   ┌────────────────────────────────────────────────────────────┐   │
│   │                  Jenkins Pipeline                          │   │
│   │                                                            │   │
│   │   Checkout  →  terraform init  →  terraform plan          │   │
│   │                                      │                    │   │
│   │                               terraform apply             │   │
│   └──────────────────────────────────────┬─────────────────────┘   │
└──────────────────────────────────────────┼──────────────────────────┘
                                           │  AWS API Calls
                                           │  (via aws configure)
                                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          AWS Cloud                                  │
│                                                                     │
│   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐      │
│   │   VPC    │   │  Subnet  │   │    EC2   │   │   S3     │      │
│   │          │   │          │   │ Instance │   │  Bucket  │      │
│   └──────────┘   └──────────┘   └──────────┘   └──────────┘      │
│                  Provisioned by Terraform                           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🧰 Tech Stack

| Tool | Version | Role |
|---|---|---|
| **Terraform** | 1.11.3 | Infrastructure as Code |
| **Jenkins** | Latest Stable | CI/CD Pipeline |
| **AWS CLI** | Latest | AWS Authentication |
| **Java (OpenJDK 11)** | 11 | Jenkins Runtime |
| **Amazon Linux** | 2 | Host OS |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| **AWS Account** | With IAM user + Access Key & Secret Key |
| **Amazon Linux 2 EC2** | t2.micro or above |
| **Security Group** | Port `8080` open for Jenkins UI |
| **IAM Permissions** | EC2, S3, VPC (or `AdministratorAccess` for lab) |

---

## ⚙️ Phase 1: Terraform Installation

### Step 1 – Download Terraform

```bash
wget https://releases.hashicorp.com/terraform/1.11.3/terraform_1.11.3_linux_amd64.zip
```

### Step 2 – Install & Extract

```bash
apt install unzip -y
unzip terraform_1.11.3_linux_amd64.zip
```

### Step 3 – Move to System PATH

```bash
mv terraform /usr/local/bin/
```

### Step 4 – Verify Installation

```bash
terraform -v
```

Expected output:
```
Terraform v1.11.3
on linux_amd64
```

---

## ☁️ Phase 2: AWS CLI Setup

### Step 1 – Install AWS CLI

```bash
apt update -y
apt install awscli -y
```

### Step 2 – Configure AWS Credentials

```bash
aws configure
```

You will be prompted for:

```
AWS Access Key ID:     <your-access-key>
AWS Secret Access Key: <your-secret-key>
Default region name:   us-east-1
Default output format: json
```

> 💡 Credentials are stored at `~/.aws/credentials` and used by Terraform automatically.

---

## 🟧 Phase 3: Jenkins Installation (Amazon Linux)

### Step 1 – Install Java 11

```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

### Step 2 – Add Jenkins Repository

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  http://pkg.jenkins-ci.org/redhat/jenkins.repo
```

### Step 3 – Import GPG Keys

```bash
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
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

### Step 6 – Verify Jenkins is Running

```bash
sudo systemctl status jenkins
```

### Step 7 – Get Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

> 🌐 Access Jenkins at: `http://<your-ec2-public-ip>:8080`

---

## 🔌 Phase 4: Connect Jenkins to Terraform

### Install the Terraform Plugin in Jenkins
1. Go to **Manage Jenkins → Plugins → Available**
2. Search for **Terraform** and install it
3. Go to **Manage Jenkins → Tools → Terraform**
4. Point it to `/usr/local/bin/terraform`

### Sample Jenkinsfile

```groovy
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-org/your-tf-repo.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
```

---

## 📂 Recommended Project Structure

```
jenkins-terraform/
├── main.tf               ← Core infrastructure resources
├── variables.tf          ← Input variable declarations
├── outputs.tf            ← Output values
├── terraform.tfvars      ← Variable values (do not commit secrets)
├── Jenkinsfile           ← CI/CD pipeline definition
└── README.md
```

---

## 🌐 Key URLs & Ports

| Service | URL | Default Credentials |
|---|---|---|
| **Jenkins UI** | `http://<ec2-ip>:8080` | Initial password from `initialAdminPassword` |
| **Terraform Registry** | `https://registry.terraform.io` | — |
| **Terraform Download** | `https://releases.hashicorp.com/terraform/` | — |

---

## 📂 Key File Locations

| File | Path | Purpose |
|---|---|---|
| Terraform binary | `/usr/local/bin/terraform` | CLI tool |
| AWS credentials | `~/.aws/credentials` | Auth for AWS API |
| Jenkins password | `/var/lib/jenkins/secrets/initialAdminPassword` | First login |
| Jenkins home | `/var/lib/jenkins/` | Jobs, plugins, config |
| Jenkins repo | `/etc/yum.repos.d/jenkins.repo` | Yum repo config |

---

## ⚠️ Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| `terraform: command not found` | Binary not in PATH | Run `mv terraform /usr/local/bin/` |
| Jenkins UI not reachable | Port 8080 blocked | Open port `8080` in EC2 Security Group |
| `aws configure` not saving | Wrong user context | Run as the same user Jenkins uses |
| Jenkins won't start | Java not installed | Run `java -version` to confirm JDK 11 |
| Terraform apply fails | AWS credentials missing | Run `aws configure` and verify with `aws sts get-caller-identity` |

---

## 🔄 Pipeline Flow Summary

```
git push  →  Jenkins triggers  →  terraform init
                                       │
                                  terraform plan
                                       │
                                  terraform apply
                                       │
                               AWS Resources Created 🎉
```
