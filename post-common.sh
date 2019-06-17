#!/usr/bin/env bash
set -o nounset

BASE_DIR=$(dirname "$0")

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

set +o errexit

/opt/puppetlabs/bin/puppet apply \
  --detailed-exitcodes \
  --modulepath "${BASE_DIR}"/modules \
  --execute "include aem_helloworld::post_common"

translate_puppet_exit_code "$?"

set -o errexit

# Specify HOME env var explicitly for inspec here due to intermittent failure
# when pry gem attempts to resolve its config https://github.com/pry/pry/blob/v0.12.2/lib/pry/pry_class.rb#L5
# NOTE: their master branch no longer has pry config with home dir tilde expansion
HOME=/root /opt/puppetlabs/puppet/bin/inspec exec "${BASE_DIR}"/test/post_common.rb
