# Terraform Project

Terraform Project provisions a highly available infrastructure using Infrastructure as Code (IaC) principles with a VPC, subnets, ALBs, EC2 instances, security groups, and other resources. It uses S3 and DynamoDB for state management and follows a modular approach using Terraform modules.

## Note

- You must have your own key in the project working directory.

## How to Use

To use Terraform Project, follow these steps:

1. Clone the repository to your local machine.
2. Install the AWS CLI and Terraform on your machine.
3. Configure your AWS credentials.
4. Run the following Terraform commands:
    - `terraform workspace new dev`: This creates a new workspace named "dev".
    - `terraform init`: This initializes the Terraform project and downloads the necessary providers.
    - `terraform plan`: This generates an execution plan that shows the changes to be made to the infrastructure.
    - `terraform apply`: This applies the changes to the infrastructure.
5. After the `terraform apply` command completes successfully, put the public load balancer DNS in a browser to see the output of Apache.

To destroy all resources created by Terraform Project, run the following command:

- `terraform destroy`
