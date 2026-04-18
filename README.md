# aws-multi-account-agents

## Overview

This repository demonstrates a **hub-and-spoke AWS multi-account architecture** where **networking is centrally managed and shared** across workload accounts using **AWS Resource Access Manager (RAM)**.

Instead of duplicating VPCs and subnets in every account, a central *hub account* owns and manages networking, while *spoke accounts* deploy isolated workloads (such as CI/CD agents) into **RAM-shared subnets**.

## Architecture

![High-level architecture showing hub-owned networking shared to spoke accounts via AWS RAM.](/docs/architecture-diagram.png)

- **Hub Account**
  - Owns VPC, subnets, routing, NAT, and network security.
  - Shares private subnets with workload accounts using AWS RAM.

- **Spoke Accounts**
  - Deploy compute (EC2 / ECS / EKS).
  - Maintain isolated IAM roles and workload ownership.
  - Consume centrally managed networking.

## Key Capabilities

- Hub-and-spoke AWS multi-account design.
- Centralised VPC and subnet management.
- AWS RAM-based subnet sharing.
- EKS/ ECS based CI/CD agent deployment (example workload).
- Clear separation of networking and workload concerns.
- Infrastructure-as-Code using Terraform and Terragrunt.

## Repository Structure

```text
terraform/
  ├── hub/         # Central networking account (VPC, RAM)
  ├── spoke/       # Workload accounts (compute, IAM)
workloads/
  └── ado-agent/   # Example ECS-based CI/CD agent
docs/              # Architecture diagrams and additional documentation
```

## Design Goals

- Minimise duplicated networking infrastructure across AWS accounts.
- Improve operational consistency and cost efficiency.
- Keep IAM and workloads isolated per account.
- Provide a reusable reference architecture for platform teams.

## Usage

See the documentation under [/docs](/docs/usage.md) for deployment guidance.

## Trade-offs & Considerations

While this architecture reduces duplication and centralises networking, it introduces several trade-offs:
- **Blast Radius**
  - Networking issues in the hub account can impact all spoke accounts.
- **Reduced Isolation**
  - Shared subnets weaken strict account-level network isolation.
- **Governance Complexity**
  - Requires clear ownership boundaries between platform and workload teams.
- **Operational Coupling**
  - Changes to networking must be coordinated across accounts.


## Future Improvements
- Integrate AWS Network Firewall for centralised traffic inspection.
- Explore cross-account observability and logging patterns.

## Author

👤 Jazzy Jeff
