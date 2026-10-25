[![Build Status](https://github.com/shinesolutions/aem-helloworld-custom-stack-provisioner/workflows/CI/badge.svg)](https://github.com/shinesolutions/aem-helloworld-custom-stack-provisioner/actions?query=workflow%3ACI)
[![Known Vulnerabilities](https://snyk.io/test/github/shinesolutions/aem-helloworld-custom-stack-provisioner/badge.svg)](https://snyk.io/test/github/shinesolutions/aem-helloworld-custom-stack-provisioner)

# AEM Hello World Custom Stack Provisioner

This is an example AEM Hello World Custom Stack Provisioner artifact that will be set up as one of [AEM AWS Stack Builder customisation points](https://github.com/shinesolutions/aem-aws-stack-builder/blob/main/docs/customisation-points.md#custom-stack-provisioner).

This artifact contains:

* `pre-common.sh` shell script which will be executed before component stack provisioning
* `post-common.sh` shell script which will be executed after component stack provisioning
* Example [Puppet module](https://www.openvoxproject.org/docs/openvox/latest/modules_fundamentals.html) manifests in `modules/aem_helloworld` directory, applied with OpenVox 9
* Example [InSpec tests](https://cinc.sh/start/auditor/) which will check the result of the above Puppet module, run with the `inspec` command of Cinc InSpec, which the AMI must provide

Here's an example log output of the post step:

![Post step log output](https://raw.githubusercontent.com/shinesolutions/aem-helloworld-custom-stack-provisioner/master/docs/post-step-log.png)

The use of Puppet and InSpec here is just an example. You can use other tools like Ansible, or even plain shell script if need be.
They can be installed either in [Packer AEM source image](https://github.com/shinesolutions/packer-aem/blob/main/docs/customisation-points.md#source-image) or [Packer AEM custom image provisioner](https://github.com/shinesolutions/packer-aem/blob/main/docs/customisation-points.md#custom-image-provisioner).

## Usage

To create artifact tar.gz file:

    make package

The artifact will be written at `stage/aem-helloworld-custom-stack-provisioner-<version>.tar.gz`

Copy the tar.gz artifact file to AEM AWS Stack Builder, please note that the file must be (re)named to `aem-custom-stack-provisioner.tar.gz`:

    cp stage/aem-helloworld-custom-stack-provisioner-<version>.tar.gz <path/to/aem-aws-stack-builder>/stage/custom/aem-custom-stack-provisioner.tar.gz

If you are using Puppet, the following facts are available:

| Fact | Description |
| --- | --- |
| `$facts['component']` | The component name, useful for identifying which image is being provisioned. |

Read them from `$facts` rather than as top-scope variables (`$::component`): OpenVox 9 enables `strict_variables`, so an unset top-scope variable fails the run.

If you need more information from the provisioning process, you can tap into the Hiera data by adding `-hiera_config='/tmp/packer-puppet-masterless/hiera.yaml` flag to your Puppet apply call.

## Testing

AEM Hello World Custom Stack Provisioner targets OpenVox 9 and Cinc InSpec 7 on Amazon Linux 2023 and Rocky Linux 10.

Run the commands below in [AEM Platform BuildEnv](https://github.com/shinesolutions/aem-platform-buildenv) (`shinesolutions/aem-platform-buildenv:6.4.1`), as CI does:

| Command | Runs |
| --- | --- |
| `make deps` | Install the Ruby gems with Bundler |
| `make lint` | ShellCheck, yamllint, markdownlint, puppet-lint, Puppet manifest validation and RuboCop |
| `make test` | The catalog tests of the `aem_helloworld` classes in `spec/classes` with rspec-puppet |
| `make package` | Package the provisioner into `stage/aem-helloworld-custom-stack-provisioner-<version>.tar.gz` |
| `make acceptance` | Package the provisioner and run the acceptance tests in `spec/acceptance` with Beaker on Docker, on every nodeset |
| `make ci` | Everything CI runs: clean, deps, lint, test, package and acceptance |

The acceptance tests ([voxpupuli-acceptance](https://github.com/voxpupuli/voxpupuli-acceptance)) unpack the package and run `pre-common.sh` and
`post-common.sh` as AEM AWS Stack Builder does, on the nodesets in `spec/acceptance/nodesets`: stand-ins for the AEM AMIs, Amazon Linux 2023
and Rocky Linux 10 with OpenVox 9 and Cinc InSpec 7.2.1.
