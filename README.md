# Socrata Chef Cookbook Generator

A Socrata-flavored generator for new Chef cookbooks.

## General

This repository started as a fork of [chef-dk](https://github.com/chef/chef-dk) and should occasionally be rebased.

The included generator cookbook adds all of our boilerplate on top of the default one. Additions include, but are not limited to:

- Modify the Berksfile to use our shared remote file from GitHub.
- Add default values for the copyright holder, contact email, etc.
- Modify the Delivery config to use our shared remote file from GitHub.
- For open source cookbooks, generate a TravisCI configuration.
- Patch the metadata template to assume Chef 12+.
- Patch the CHANGELOG template to include release dates.
- Add a CODE_OF_CONDUCT file.
- Add a CONTRIBUTING file.
- Add a Gemfile.
- Modify the README template to be more complete.
- Add a TESTING file.
- Modify the ChefSpec templates to use our testing and coverage defaults.
- Modify the resource templates to be more complete and have ChefSpec tests.
- Assume use of kitchen-microwave and don't write a `.kitchen.yml`.

## Requirements

Cookbook generators require the [Chef-DK](https://github.com/chef/chef-dk) be already installed.

## Usage

First, clone this project from GitHub:

```shell
$ git clone https://github.com/socrata-cookbooks/generator
```

Then generate either a proprietary (default) or open source cookbook in the current working directory:

```shell
$ chef generate cookbook -g generator/skeletons/code_generator proprietary_cookbook

$ chef generate cookbook -I apachev2 -g generator/skeletons/code_generator oss_cookbook
```
