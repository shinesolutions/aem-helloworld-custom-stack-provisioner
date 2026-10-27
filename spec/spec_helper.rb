# frozen_string_literal: true

require 'voxpupuli/test/spec_helper'

# The module isn't a Forge module with fixtures: its classes are loaded from modules/, as pre-common.sh and
# post-common.sh pass it to puppet apply as --modulepath
RSpec.configure do |c|
  c.module_path = File.expand_path('../modules', __dir__)
end

# The OSes the AEM AMIs are built on (there is no metadata.json to read them from).
# A method rather than a frozen constant, as on_supported_os modifies the options it's given
def supported_os
  {
    supported_os: [
      { 'operatingsystem' => 'Amazon', 'operatingsystemrelease' => ['2023'] },
      { 'operatingsystem' => 'Rocky', 'operatingsystemrelease' => ['10'] }
    ]
  }
end
