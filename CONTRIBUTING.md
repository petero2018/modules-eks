# Contributing

Anyone is free to create a PR and create/update any module features that they believe are required. The following is a list of best practice for adding a module.

* Correct folder structure. See [Folder Structure ](#folder-structure)
* Example usage of module
* Terraform documentation (Should be generate automatically. See [Modules documentation](#modules-documentation))
* Required terraform providers

## Workflow

If you need to make changes to a module you should do the following:

- Clone this repo locally
- Change the terraform `source` parameter for the affected modules to point to your local checkout
- Work on your changes
- Commit changes to a branch and raise a PR
- Once PR is merged, bump the tag according to the tagging policy
- Raise a PR against the uses of the module you wish to upgrade to use the new tag

## Versioning

All modules are versioned and should use the file path as a tag prefix e.g. `aws/master-0.0.1`.

Version tags follow [semver](https://semver.org) which is of the form `<MAJOR>.<MINOR>.<PATCH>`.

- `PATCH` should be bumped for minor fixes or additions that do not break uses of the module
- `MINOR` should be bumped for fixes or additions that add features but do not break uses of the module
- `MAJOR` should be bumped for major changes that would break uses of the module

All modules should be formatted with `terraform fmt`.

## Modules documentation

The documentation for the new modules are generated automatically with a pre-commit hook that runs [terraform-docs](https://github.com/terraform-docs/terraform-docs).

## Folder Structure

At a high level, folders should be organized by the high level provider for the module. For example, these would be considered high level folders: `aws`, `datadog`, `kubernetes` etc.

Broadly speaking, the folder structure should be as follows:

`<provider>/<service>/<module-name>`

Keep this in mind when adding/updating a module.
