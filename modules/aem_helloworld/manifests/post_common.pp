class aem_helloworld::post_common (
) {

  notify { 'Display status message with component name':
    message => "Executing Custom Stack Provisioner post-common step for component ${::component}",
  }

  file { '/opt/aem-helloworld-custom-stack-provisioner/':
    ensure => directory,
    mode   => '0775',
  }

  file { "/opt/aem-helloworld-custom-stack-provisioner/${::component}-post.txt":
    ensure => present,
    mode   => '0664',
  }

}
