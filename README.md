# Use OpenTofu as IoC to setup Drupal hosting on AWS

## Preparations
- Create or log into an existing AWS account
- Use Identity and Access Management (IAM) to create a user group "opentofu" and grand following permissions:
  - AmazonEC2FullAccess for compute instances (also networking required for it)
  - AmazonRoute53FullAccess for DNS management
  - AmazonRDSFullAccess for remote database
  - AmazonS3FullAccess to store tfstate
  - AmazonDynamoDBFullAccess to lock tfstate and prevent change conflicts
- In IAM create a user and add it to opentofu group.
- Navigate to security credentials of the newly created user and create a new access key.
- Install opentofu and aws on the machine.
- Run `aws configure` in the terminal and use Access Key and Security.

## Fresh start
When starting with a new AWS account or if S3 and DynamoDB aren't setup yet follow this:
- Comment out lines 2-8 in `./general/main.tf` then execute `opentofu init` followed by `opentofu plan` and
`opentofu apply` in that directory `general`.
- Uncomment lines 2-8 in `./main.tf` and execute `opentofu init` again, which will move tfstate to the remote bucket.

## How to use OpenTofu
- When first cloned `opentofu init` must be run to download providers, modules, tc.
- `opentofu -chdir=./live plan` compares current state with desired state, so run it after changing the code.
- `opentofu -chdir=./live apply -auto-approve` applies the desired state of the infrastructure.
- `opentofu -chdir=./live destroy -auto-approve` destroys the infrastructure.

## Building blocks in app module
- We are using compute instances to serve apps in `compute.tf` (EC2 in AWS)
- We are using dns management to connect the domain `dns.tf` (Route 53 in AWS)
- We are using remote database for app `database.tf`  (RDS in AWS)
- All the networking vpc, security groups, load balancer are done in `network.tf` as I don't understand clearly what they do yet.

## Gotchas
- Terraform timeouts - can cause issues 
- Name changes DESTROY things
- Don't forget to destroy resources - cloud nuke?

## TODO
- Learn what each component does
- Allow setting number of replicas easily
- Allow installing drupal or wordpress in the instance
- Can or should I use Cloudflare for DNS?