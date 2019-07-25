class aem_helloworld::pre_common (
) {

  notify { 'Display status message with component name':
    message => "Executing Custom Stack Provisioner pre-common step for component ${::component}",
  }

  file { '/opt/aem-helloworld-custom-stack-provisioner/':
    ensure => directory,
    mode   => '0775',
  }

  file { "/opt/aem-helloworld-custom-stack-provisioner/${::component}-pre.txt":
    ensure => present,
    mode   => '0664',
  }

  # Only temporary while trialling CIS-benchmarked RHEL7 AMIs on Sandpit
  # TODO: keep iptables running, configure correct permissions
  service { 'iptables':
    ensure => 'stopped',
  }
  # TODO: configure auditd to log less aggressive
  service { 'auditd':
    ensure => 'stopped',
  }
}
