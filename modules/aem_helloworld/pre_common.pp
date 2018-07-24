class aem_helloworld::pre_common (
) {

  notify { 'Display component name':
    message => "Executing Custom Stack Provisioner pre-common step for component ${::component}",
  }

}
