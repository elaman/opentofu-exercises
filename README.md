# Use OpenTofu as IoC to setup Drupal hosting on AWS

## Preparations
- Create or log into an existing AWS account
- Use Identity and Access Management (IAM) to create a user group "opentofu" and grand following permissions:
AmazonEC2FullAccess, AmazonRoute53FullAccess, AmazonRDSFullAccess.
- In IAM create a user and add it to opentofu group.
- Navigate to security credentials of the newly created user and create a new access key.
- Install opentofu and aws on the machine.
- Run `aws configure` in the terminal and use Access Key and Security.


## How to use OpenTofu
- When first cloned `opentofu init` must be run to download providers, modules, tc.
- `opentofu plan` compares current state with desired state, so run it after changing the code.
- `opentofu apply` applies the desired state of the infrastructure.
- `opentofu destroy` destroys the infrastructure.
 

## Building blocks in app module
- We are using compute instances to serve apps in `compute.tf` (EC2 in AWS)
- We are using dns management to connect the domain `dns.tf` (Route 53 in AWS)
- We are using remote database for app `database.tf`  (RDS in AWS)
- All the networking vpc, security groups, load balancer are done in `network.tf` as I don't understand clearly what they do yet.

## TODO
- Learn what each component does
- Allow setting number of replicas easily
- Allow creating environments
- Allow installing drupal or wordpress in the instance