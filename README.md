# Use OpenTofu as IoC to setup Drupal hosting on AWS

## Preparations
- Create or log into an existing AWS account
- Use Identity and Access Management (IAM) to create a user group "opentofu" and grand following permissions: AmazonEC2FullAccess.
- In IAM create a user and add it to opentofu group.
- Navigate to security credentials of the newly created user and create a new access key.
- Install opentofu and aws on the machine.
- Run `aws configure` in the terminal and use Access Key and Security.


## How to use OpenTofu
- When first cloned `opentofu init` must be run to download providers, modules, tc.
- `opentofu plan` compares current state with desired state, so run it after changing the code.
- `opentofu apply` applies the desired state of the infrastructure.
- `opentofu destroy` destroys the infrastructure.
 