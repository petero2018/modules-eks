# Installation

## Tools

You will need the following tools to work with this repository:

- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- [pre-commit](https://pre-commit.com/#install) (optional but recommended)
- [tflint](https://github.com/terraform-linters/tflint)
- [checkov](https://github.com/bridgecrewio/checkov)
- [terraform-docs](https://terraform-docs.io/user-guide/installation/)

## Consumer Setup (use modules in another repository)

Use this path when you only want to consume modules from this repository in your own Terraform stack.

1. Install Terraform CLI.
2. Reference a module with a pinned git ref in your Terraform code:

```hcl
module "example_bucket" {
  source = "git@github.com:powise/terraform-modules//aws/s3/bucket?ref=aws-s3-bucket-2.0.0"

  bucket_name = "example-bucket"
  tags = {
    team    = "platform"
    service = "example"
    impact  = "high"
  }
}
```

3. Run:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`

## Contributor Setup (work in this repository)

Use this path when you want to add or modify modules in this repository.

1. Install Terraform CLI.
2. Clone the repository locally.
3. (Optional) Install pre-commit hooks:
   - `brew install pre-commit`
   - `pre-commit install`
4. Install hook dependencies used by this repository:
   - `tflint`
   - `checkov`
   - `terraform-docs`
5. Verify your setup:
   - `terraform fmt -recursive`
   - `pre-commit run --all-files` (if pre-commit is installed)

### Terraform

We use Terraform to manage our infrastructure as code. With Terraform, we can define and provision our infrastructure resources in a declarative manner, allowing us to easily create, modify, and destroy infrastructure components. This enables us to version control our infrastructure configurations, collaborate effectively, and ensure consistency across different environments. By leveraging Terraform's powerful features, we can automate the deployment and management of our infrastructure, making it more scalable, reliable, and maintainable.

### Pre-commit hooks

In order to keep terraform files formatted consistently across the entire repo, you can *optionally* install [pre-commit hooks](https://pre-commit.com/) to apply it automatically so you don't have to run `terraform fmt` manually before opening a pull request. Just run `brew install pre-commit` and `pre-commit install` to auto-format the files when you create a commit.
The pre-commit hooks on this repository also run [tflint](https://github.com/terraform-linters/tflint), [checkov](https://github.com/bridgecrewio/checkov), and [terraform-docs](https://terraform-docs.io/user-guide/installation/) to enforce best practices and detect security issues, so make sure you have them installed to execute hooks successfully.

A local hook also runs to keep the module list up to date in the README

The pre-commit hooks will also run on a github action to validate if there's an issue being introduced on the pull-request.
