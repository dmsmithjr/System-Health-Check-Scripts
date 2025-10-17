# 💻 Linux System Health Check Script (Bash)

## 🎯 Project Overview

This is a lightweight, zero-dependency Bash script designed for **automated, daily health monitoring** of Linux servers (including WSL environments). It quickly gathers crucial system metrics and applies simple alerting logic to proactively detect resource exhaustion before it causes service outages.

This script is ideal for cron-scheduled execution in environments where installing Python or other dependencies is restricted.

***

## ✨ Key Features

* **Core Metrics:** Checks CPU load averages, RAM usage, and System Uptime.
* **Critical Alerting:** Implements conditional logic to flag alerts if key resources exceed predefined thresholds (e.g., Disk Usage > 90%).
* **Service Monitoring:** Verifies the running status of critical services (e.g., SSH Daemon).
* **Automated Reporting:** Generates a timestamped, plain-text log file (`health_report_YYYY-MM-DD_HHMMSS.txt`) for easy review and archival.
* **Cron-Ready:** Designed to run reliably without user interaction.

***

## 🛠️ Usage and Installation

### Prerequisites

This script requires **no external dependencies** (like `psutil` or Python). It uses standard Linux utilities like `df`, `free`, `uptime`, and `systemctl`.

### Step 1: Clone the Repository

Clone this repository to your Linux server or WSL environment:

```bash
git clone [https://github.com/](https://github.com/)[dmsmithjr]/[System-Health-Check-Scripts].git
cd [YourRepoName]
