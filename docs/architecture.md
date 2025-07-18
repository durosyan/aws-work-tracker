# 🏗️ Project Architecture: AWS Work Tracker

## 🎯 Purpose

This project is a serverless time-tracking tool designed to help workers with irregular schedules track their shifts and break times. The system is built to demonstrate key skills in cloud infrastructure, frontend design, event-based logging, and Infrastructure as Code (IaC) using Terraform.

---

## 📐 High-Level Architecture Overview

The application consists of three main layers:

### 1. **Frontend UI (React)**
- Hosted via S3
- Offers four main controls: Clock In, Clock Out, Break Start, Break End
- Displays current work status based on backend state
- Sends HTTPS requests to backend API endpoints

### 2. **API Backend (AWS Lambda + API Gateway)**
- Receives incoming button events from the frontend
- Each Lambda handler maps to a specific event type:
  - `clock_in`, `clock_out`, `break_toggle`
- Processes and stores timestamped event logs

### 3. **Data Store (DynamoDB)**
- Stores structured event logs with user-specific keys
- Designed for easy querying by date and event type
- Enables potential analytics in future versions

---

## ⚙️ Infrastructure Deployment

All cloud resources are provisioned via **Terraform**, allowing repeatable infrastructure management. This includes:

- S3 bucket for hosting frontend assets
- API Gateway routes and Lambda functions
- DynamoDB table with access-pattern-first schema
- IAM roles and permissions for secure communication
- Optional GitHub Actions workflow to automate deployments

---

## 🔐 Authentication (Optional MVP Extension)

If time permits, basic authentication can be added using:
- AWS Cognito for secure user sign-in
- Token-based middleware in Lambda for request verification

---

## 📈 Scaling Considerations

The architecture is modular and scalable:
- New event types can be added with separate Lambda handlers
- Multi-user support via `PK = USER#{username}` in DynamoDB
- Slack or SMS integrations could be added for alerts or confirmations
- Scheduled summary reports via Lambda cron jobs

---

## 🖼️ System Diagram

```mermaid
graph TD
  A[Frontend UI (S3 Hosted)] --> B[API Gateway]

  B --> C1[Lambda: Clock In]
  B --> C2[Lambda: Clock Out]
  B --> C3[Lambda: Break Toggle]

  C1 --> D[DynamoDB]
  C2 --> D
  C3 --> D

  D --> E[Response Sent Back to Frontend]
```

---

## 🚀 Summary

This architecture highlights:
- Clean separation of logic across layers
- A serverless-first mindset using AWS-native tools
- Infrastructure automation using Terraform
- Real-world applicability for shift-based scheduling

