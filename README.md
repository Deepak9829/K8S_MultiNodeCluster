# Provisioning Kubernetes Cluster on AWS EC2 with Terraform and Ansible

This project automates the provisioning of a Kubernetes cluster on Amazon Web Services (AWS) EC2 instances using Terraform for infrastructure provisioning and Ansible for configuring Kubernetes components.

## Overview

Setting up a Kubernetes cluster manually on cloud infrastructure can be time-consuming and error-prone. This project aims to streamline the process by automating the provisioning of infrastructure and configuration of Kubernetes components using Terraform and Ansible, respectively.

## Features

- **Infrastructure as Code (IaC)**: Provision AWS EC2 instances and related resources using Terraform scripts.
- **Kubernetes Configuration**: Configure Kubernetes components (e.g., kubelet, kube-proxy) using Ansible playbooks.
- **Customization**: Easily customize the cluster configuration and scale according to your requirements.

## Prerequisites

Before using this project, ensure you have the following prerequisites installed and configured:

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- AWS account with appropriate permissions configured for Terraform to manage resources.

## Setup Instructions

1. Clone this repository:

    ```bash
    git clone https://github.com/Deepak9829/K8S_MultiNodeCluster.git
    ```

2. Navigate to the repository directory:

    ```bash
    cd K8S_MultiNodeCluster/EC2
    ```

3. Update variables in Terraform configuration files (`terraform/`) and Ansible playbooks (`ansible/`) according to your AWS environment and Kubernetes configuration.

4. Initialize Terraform:

    ```bash
    cd terraform/
    terraform init
    ```

5. Review the changes that Terraform will make:

    ```bash
    terraform plan
    ```

6. Apply the Terraform configuration to provision the infrastructure:

    ```bash
    terraform apply
    ```

7. Once infrastructure provisioning is complete, execute Ansible playbooks to configure Kubernetes components:

    ```bash
    cd ../ansible/
    ansible-playbook -i inventory.ini playbook.yml
    ```

8. After successful execution, you should have a fully functional Kubernetes cluster running on AWS EC2 instances.

## Usage

- Use `kubectl` to interact with the Kubernetes cluster.
- Deploy applications, manage resources, and monitor the cluster as per your requirements.
- Refer to the Kubernetes documentation for more information on managing Kubernetes clusters and deploying applications.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.


## Acknowledgments

Special thanks to contributors and the open-source community for their valuable contributions and support.

