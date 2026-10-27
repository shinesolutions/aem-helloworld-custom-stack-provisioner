# The component fact is read from $facts, as OpenVox 9 enables strict_variables, under which an unset
# top-scope variable fails the run
class aem_helloworld::post_common (
) {
  notify { 'Display status message with component name':
    message => "Executing Custom Stack Provisioner post-common step for component ${facts['component']}",
  }

  file { '/opt/aem-helloworld-custom-stack-provisioner/':
    ensure => directory,
    mode   => '0775',
  }

  file { "/opt/aem-helloworld-custom-stack-provisioner/${facts['component']}-post.txt":
    ensure => present,
    mode   => '0664',
  }
}
