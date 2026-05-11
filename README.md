# Offensive GCP PoCs

A curated collection of Proof of Concepts (PoCs) demonstrating security vulnerabilities and misconfigurations within Google Cloud Platform (GCP).

## 📁 Project Structure

This repository is organized by exploit categories:

- **[privesc/](./privesc/)**: Privilege Escalation techniques.
  - `iam-token-creator-privesc.sh`: Abusing `roles/iam.serviceAccountTokenCreator` to escalate privileges via service account impersonation.

## 🛠️ Usage

Each PoC is designed for educational and security assessment purposes.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/offensive-gcp.git
   cd offensive-gcp
   ```

2. **Run a PoC:**
   Follow the instructions within the individual scripts. Most require the `gcloud` CLI to be authenticated and pointed at a test project.

## 🛡️ Security Disclaimer

**WARNING:** These scripts are for educational and authorized testing only. Never run these against production environments or projects you do not have explicit permission to test. The authors are not responsible for any damage or misuse of this information.

---
*Maintained for security research and hardening validation.*
