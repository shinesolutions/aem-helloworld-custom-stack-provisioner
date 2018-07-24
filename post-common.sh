#!/usr/bin/env bash
set -o nounset
set -o errexit

echo "[aem-helloworld] Executing Custom Stack Provisioner post-common step..."

# Translate puppet detailed exit codes to basic convention 0 to indicate success.
# More info on Puppet --detailed-exitcodes https://puppet.com/docs/puppet/5.3/man/agent.html
translate_puppet_exit_code() {

  exit_code="$1"

  # 0 (success) and 2 (success with changes) are considered as success.
  # Everything else is considered to be a failure.
  if [ "$exit_code" -eq 0 ] || [ "$exit_code" -eq 2 ]; then
    exit_code=0
  else
    exit "$exit_code"
  fi

  return "$exit_code"
}

/opt/puppetlabs/bin/puppet apply \
--debug \
--detailed-exitcodes \
--modulepath modules \
--execute "include aem_helloworld::post_common"

translate_puppet_exit_code "$?"
