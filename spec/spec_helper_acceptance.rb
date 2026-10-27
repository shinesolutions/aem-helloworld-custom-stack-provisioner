# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

# The acceptance tests run the package as aem-aws-stack-builder's stack-init.sh does, without AWS and AEM:
# the nodeset is the AMI (see its comments), the package from `make package` is unpacked into INSTALL_DIR,
# and the component fact is passed as a FACTER_component environment variable.

# The nodesets bake OpenVox 9 in, as the AMIs do, so configure_beaker doesn't install an agent
ENV['BEAKER_PUPPET_COLLECTION'] ||= 'preinstalled'

INSTALL_DIR = '/opt/shinesolutions/aem-custom-stack-provisioner'

# The package `make package` built
def provisioner_package
  Dir.glob('stage/aem-helloworld-custom-stack-provisioner-*.tar.gz').max_by { |path| File.mtime(path) } ||
    raise('No package in stage/, run make package first')
end

def install_provisioner(host)
  scp_to(host, provisioner_package, '/tmp/aem-custom-stack-provisioner.tar.gz')
  on(host, "mkdir -p #{INSTALL_DIR} && tar -xzf /tmp/aem-custom-stack-provisioner.tar.gz -C #{INSTALL_DIR} " \
           '&& rm /tmp/aem-custom-stack-provisioner.tar.gz')
end

# Runs a step's script for the given component
def run_step(step, component)
  on(default, "FACTER_component=#{component} #{INSTALL_DIR}/#{step}-common.sh")
end

configure_beaker(modules: nil) do |host|
  install_provisioner(host)
end
