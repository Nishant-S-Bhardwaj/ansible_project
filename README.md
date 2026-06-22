Markdown# 🚀 AWS EC2 Fleet Monitoring & Automated Reporting System

> Transforming manual cloud operations into a fully automated infrastructure monitoring pipeline using AWS CLI, Bash, Linux, Ansible, Jinja2 templates, and Gmail SMTP.

![AWS](https://img.shields.io/badge/AWS-EC2-orange?style=for-the-badge&logo=amazonaws)
![Ansible](https://img.shields.io/badge/Ansible-Automation-red?style=for-the-badge&logo=ansible)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-yellow?style=for-the-badge&logo=linux)
![Bash](https://img.shields.io/badge/Bash-Automation-green?style=for-the-badge&logo=gnu-bash)
![DevOps](https://img.shields.io/badge/DevOps-Infrastructure-blue?style=for-the-badge)

---

## 🎯 Project Motivation & Design Philosophy

Managing a handful of EC2 instances manually is trivial. Managing **50 to 100+ instances** manually is an operational nightmare. Tasks like tracking dynamic IP addresses, updating inventory sheets, provisioning SSH keys, logging into boxes to run health checks, and aggregating report cards quickly become error-prone, unscalable, and inefficient.

The core philosophy of this project is simple:
> **"If a task is performed repeatedly, it must be automated so engineers can focus on solving high-value problems."**

This project establishes a self-contained, end-to-end monitoring pipeline that eliminates human intervention across the entire fleet management lifecycle.

---

## 🏗️ Architecture & Workflow

The system follows a linear pipeline architecture, taking target instances from raw AWS deployment to complete reporting metrics.

```text
       ┌───────────────────────────────┐
       │     AWS EC2 Instance Fleet    │  ◄── Instances launched as "Production"
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │   Automated Instance Renamer  │  ◄── Bash + AWS CLI (production-1, -2...)
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │  Dynamic Inventory Generator  │  ◄── Automatically queries public IPs
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │   Passwordless SSH Provision  │  ◄── Disseminates keys via ssh-copy-id
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │  Ansible Core Control Node    │  ◄── Executes sysstat, mpstat, free, df
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │   Jinja2 HTML Report Render   │  ◄── Builds dashboard with health indicators
       └───────────────┬───────────────┘
                       │
                       ▼
       ┌───────────────────────────────┐
       │      Gmail SMTP Gateway       │  ◄── Dispatches via Google App Passwords
       └───────────────┬───────────────┘
                       │
                       ▼
       📧 Automated Email Delivered (Hourly/Daily via Cron)
⚡ Key FeaturesEC2 Naming Standardization: Automatically detects instances launched with default or identical labels and transitions them into a clean, serialized standard (production-1, production-2, etc.).Zero-Maintenance Dynamic Inventory: Uses the AWS CLI backend to query state metadata on the fly, completely eliminating the manual copy-pasting of changing target IP addresses.Secure Unattended Execution: Sets up automated passwordless SSH key delivery so the orchestrator runs entirely without prompt-blocking bottlenecks.Tri-Core Metric Collection: Pulls deep OS stats directly through foundational Linux utilities to measure performance across critical boundaries:🔥 CPU Usage: Real-time utilization via mpstat.📥 Memory Usage: RAM consumption footprints via free.📦 Disk Usage: Root partition block space allocations via df.Data-to-Information Dashboards: Transforms raw numbers into visual asset metrics featuring health status badges, visual usage bars, and structural asset layouts via Jinja2 HTML rendering.Resilient Delivery Engine: Ships completed execution sheets directly to infrastructure teams over secure SMTP pathways utilizing Cron scheduling hooks.🛠️ Technology StackCategoryTechnologies UsedCloud ProviderAWS (EC2 Infrastructure Management)Configuration EngineAnsible CoreScripting AutomationBash, AWS CLI ToolingTarget OSLinux UbuntuTelemetry AggregatorsLinux sysstat SuiteIdentity ManagementSSH Key Pairs (ssh-copy-id)Template CompilerJinja2 EngineNotification LayerGmail SMTP Network (App Passwords)Task AutomationLinux Vixie Cron📂 Project StructurePlaintextaws-ec2-monitoring/
├── AUTHORS
├── README.md
├── collect_metrics.yaml        # Ansible task playbook for server stats
├── send_report.yaml            # Ansible task playbook for SMTP processing
├── playbook.yaml               # Master playbook chaining the execution steps
├── hosts.yaml                  # Target inventory configuration file
├── group_vars/
│   └── all.yml                 # Global configuration variables and mail configs
├── scripts/
│   ├── dyna_inven.sh           # Queries AWS for IP mapping & updates inventory
│   ├── pass_less-auth.sh       # Deploys SSH public keys to target instances
│   └── rename_instance.sh      # Re-indexes non-ordered cloud instance names
└── templates/
    └── ec2_report.html.j2      # Jinja2 layout for compiled email metrics
⚙️ Core Automation Engineering Deep-DiveStage 1: Standardizing Infrastructure NamingWhen multiple EC2 instances are spun up simultaneously, they often inherit ambiguous or duplicate tags. The following snippet loops through active resources filtering for generic "Production" labels and builds sequential naming tracks:Bash#!/bin/bash
# rename_instance.sh
COUNT=1

for INSTANCE_ID in $(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Production" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)
do
    NEW_NAME="production-${COUNT}"
    
    aws ec2 create-tags \
        --resources "$INSTANCE_ID" \
        --tags Key=Name,Value="$NEW_NAME"
        
    ((COUNT++))
done
Stage 2: Dynamic IP DiscoveryInstead of parsing cloud instances manually, this discovery query extracts the required dynamic variables directly from the active AWS endpoint:Bash#!/bin/bash
# dyna_inven.sh
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=production-*" "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value|[0],PublicIpAddress]" \
  --output text
Stage 3: Automated Key InjectionTo run tasks entirely unattended, SSH pathways are authorized programmatically by piping dynamic address inputs straight into target hosts:Bash#!/bin/bash
# pass_less-auth.sh
while read -r NAME IP; do
    if [ ! -z "$IP" ]; then
        ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ubuntu@"$IP"
    fi
done < <(./dyna_inven.sh)
🔍 Real Engineering Challenges & Root Cause InvestigationsChallenge 1: SSH Key Authentication Refusals (Permission denied (publickey))Root Cause: The Ansible controller defaults execution contextual paths to local user footprints (nishant@<IP>), causing logins to drop on generic Ubuntu EC2 setups because the default account is ubuntu.Resolution: Enforced global parameterizations inside group_vars/all.yml to normalize administrative target logins:YAMLall:
  vars:
    ansible_user: ubuntu
Challenge 2: AWS Dynamic Engine Discovery Blockages (ModuleNotFoundError: No module named 'boto3')Root Cause: Transitioning execution structures toward fully automated dynamic runtime environments triggered underlying library failures within local python runtimes.Resolution: Patched dependency definitions and initialized local collection trees via galaxy:Bashpip install boto3 botocore
ansible-galaxy collection install amazon.aws
Challenge 3: Template Attribute Mismatches during Jinja2 Engine CompileRoot Cause: The pipeline template processor threw fatal errors (object of type 'dict' has no attribute 'cpu') due to property discrepancies between raw Ansible system facts and target fields inside the custom layout file (vm.mem vs. vm.memory).Resolution: Standardized structural dictionaries across data collectors and aligned template hooks perfectly:Django<div class="metric-bar">
    <span class="label">Memory Utilization:</span>
    <span class="val">{{ vm.memory }}%</span>
</div>
Challenge 4: Authentication Handshake Failures on Mail ServicesRoot Cause: Standard account profile access passwords fail to validate against modern SMTP relays because providers require dedicated integration paths.Resolution: Modified secure credential routing to use Google App Passwords over port 587 using explicit TLS properties:YAMLsmtp_server: smtp.gmail.com
smtp_port: 587
smtp_use_tls: true
🎓 Key Lessons & DevOps TakeawaysAutomation Architecture Beats Linear Scaling: Manual processes break down quickly. Designing infrastructure pipelines to handle 100+ servers takes minimal extra up-front work but saves massive operational overhead down the line.Strict Naming Conventions are Critical: Predictable naming standards allow simpler dynamic loops, cleaner inventory generation, and much easier infrastructure auditing.Bash Remains Indispensable: While configuration engines like Ansible excel at state control, plain shell scripts remain one of the fastest and most efficient tools for rapid pre-flight orchestration and AWS API queries.Actionable Reporting Matters: Collecting raw metrics is only half the battle. A true DevOps monitoring solution must process data, visualize it clearly, and route it directly to the engineering team via reliable notification pipelines (Email/SMTP).👨‍💻 AuthorNishant Bhardwaj Final Year ECE Student | National Institute of Technology (NIT), Raipur Core Focus: DevOps Automation • Cloud Architecture • Linux Systems Engineering • Infrastructure OperationsAutomating infrastructure one script at a time 🚀. If you find this architecture template helpful for your production pipelines, please consider giving this project a star!
