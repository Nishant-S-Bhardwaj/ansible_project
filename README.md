# 🚀 AWS EC2 Fleet Monitoring & Automated Reporting System

> Automated AWS infrastructure monitoring solution that discovers EC2 instances, provisions access, collects health metrics, generates HTML dashboards, and delivers scheduled reports via email.

![AWS](https://img.shields.io/badge/AWS-EC2-orange?style=for-the-badge\&logo=amazonaws)
![Ansible](https://img.shields.io/badge/Ansible-Automation-red?style=for-the-badge\&logo=ansible)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-yellow?style=for-the-badge\&logo=linux)
![Bash](https://img.shields.io/badge/Bash-Automation-green?style=for-the-badge\&logo=gnu-bash)
![DevOps](https://img.shields.io/badge/DevOps-Infrastructure-blue?style=for-the-badge)

---

## 📖 Overview

Managing dozens of cloud instances manually becomes increasingly difficult as infrastructure scales. Tasks such as maintaining inventories, tracking IP addresses, collecting performance metrics, and generating reports consume valuable engineering time.

This project automates the entire operational workflow:

* Discover running EC2 instances dynamically
* Standardize instance naming conventions
* Configure passwordless SSH access
* Collect CPU, Memory, and Disk metrics using Ansible
* Generate HTML health reports using Jinja2
* Send automated reports through Gmail SMTP
* Schedule recurring executions via Cron

The result is a fully automated monitoring pipeline requiring minimal human intervention.

---

## ✨ Key Features

### 🔄 Automated EC2 Naming

Automatically renames newly launched instances into a predictable format:

```text
production-1
production-2
production-3
...
```

### 🌐 Dynamic Inventory Generation

Eliminates manual inventory management by querying AWS APIs directly.

### 🔐 Passwordless SSH Provisioning

Distributes SSH keys automatically for unattended Ansible execution.

### 📊 Infrastructure Health Monitoring

Collects critical system metrics:

* CPU Utilization (`mpstat`)
* Memory Utilization (`free`)
* Disk Utilization (`df`)

### 📧 Automated Reporting

* HTML Dashboard Generation
* Health Status Indicators
* Scheduled Email Delivery
* Gmail SMTP Integration

### ⏰ Scheduled Execution

Supports hourly, daily, or custom monitoring intervals using Cron.

---

## 🏗️ Architecture

```text
AWS EC2 Fleet
      │
      ▼
Instance Renaming
      │
      ▼
Dynamic Inventory Generation
      │
      ▼
SSH Key Provisioning
      │
      ▼
Ansible Metric Collection
      │
      ▼
Jinja2 HTML Report Generation
      │
      ▼
SMTP Email Delivery
      │
      ▼
Engineering Team Inbox
```

---

## 📂 Project Structure

```text
aws-ec2-monitoring/
├── AUTHORS
├── README.md
├── collect_metrics.yaml
├── send_report.yaml
├── playbook.yaml
├── hosts.yaml
├── group_vars/
│   └── all.yml
├── scripts/
│   ├── dyna_inven.sh
│   ├── pass_less-auth.sh
│   └── rename_instance.sh
└── templates/
    └── ec2_report.html.j2
```

---

## 🛠 Technology Stack

| Category       | Technologies              |
| -------------- | ------------------------- |
| Cloud          | AWS EC2                   |
| Automation     | Ansible Core              |
| Scripting      | Bash                      |
| OS             | Ubuntu Linux              |
| Monitoring     | sysstat, mpstat, free, df |
| Templates      | Jinja2                    |
| Authentication | SSH Keys                  |
| Notifications  | Gmail SMTP                |
| Scheduling     | Cron                      |

---

## 📋 Prerequisites

Before running the project, ensure the following are installed:

```bash
aws --version
ansible --version
python3 --version
```

Required packages:

```bash
pip install boto3 botocore
ansible-galaxy collection install amazon.aws
sudo apt install sysstat
```

---

## 🚀 Installation

### Clone Repository

```bash
git clone <repository-url>
cd aws-ec2-monitoring
```

### Configure AWS CLI

```bash
aws configure
```

### Configure Variables

Update:

```text
group_vars/all.yml
```

with:

```yaml
ansible_user: ubuntu

smtp_server: smtp.gmail.com
smtp_port: 587
smtp_use_tls: true

smtp_username: your-email@gmail.com
smtp_password: your-app-password
```

---

## ▶️ Usage

### Step 1: Rename Instances

```bash
./scripts/rename_instance.sh
```

### Step 2: Generate Inventory

```bash
./scripts/dyna_inven.sh
```

### Step 3: Configure Passwordless Access

```bash
./scripts/pass_less-auth.sh
```

### Step 4: Execute Monitoring Pipeline

```bash
ansible-playbook playbook.yaml
```

---

## 📈 Metrics Collected

| Metric       | Tool   |
| ------------ | ------ |
| CPU Usage    | mpstat |
| Memory Usage | free   |
| Disk Usage   | df     |

---

## 📧 Automated Reporting Workflow

1. Collect metrics from all EC2 instances
2. Aggregate results on Ansible Control Node
3. Generate HTML dashboard via Jinja2
4. Send report through Gmail SMTP
5. Deliver report to engineering team inbox

---

## 🔍 Challenges & Solutions

### SSH Authentication Failures

**Issue**

```text
Permission denied (publickey)
```

**Solution**

```yaml
ansible_user: ubuntu
```

---

### Missing AWS Python Dependencies

**Issue**

```text
ModuleNotFoundError: No module named 'boto3'
```

**Solution**

```bash
pip install boto3 botocore
ansible-galaxy collection install amazon.aws
```

---

### Jinja2 Template Errors

**Issue**

```text
object of type 'dict' has no attribute 'cpu'
```

**Solution**

Standardized metric dictionary structures across collection and reporting stages.

---

### Gmail SMTP Authentication Failures

**Solution**

Use Google App Passwords instead of account passwords.

```yaml
smtp_server: smtp.gmail.com
smtp_port: 587
smtp_use_tls: true
```

---

## 📚 Key DevOps Learnings

* Infrastructure should be designed for scale from day one.
* Consistent naming conventions simplify automation.
* Bash remains highly effective for cloud orchestration tasks.
* Monitoring is only valuable when insights are actionable.
* Automated reporting significantly reduces operational overhead.

---

## 🔮 Future Enhancements

* CloudWatch integration
* Slack/MS Teams notifications
* Grafana dashboards
* Auto-remediation workflows
* Multi-region EC2 support
* Historical metric storage with databases

---

## 👨‍💻 Author

**Nishant Bhardwaj**

Final Year ECE Student
National Institute of Technology (NIT), Raipur

**Focus Areas**

* DevOps Engineering
* Cloud Infrastructure
* Linux Systems
* Automation & Monitoring

---

## ⭐ Support

If you found this project useful, consider giving it a star and sharing feedback.

---

## 📄 License

This project is licensed under the MIT License.
