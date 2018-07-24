class aem_helloworld::post_common (
) {

  notify { 'Display component name':
    message => "Executing Custom Stack Provisioner post-common step for component ${::component}",
  }

}
