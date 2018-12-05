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
}
