# frozen_string_literal: true

require 'facter'

component = Facter.value(:component)

describe file('/opt/aem-helloworld-custom-stack-provisioner/') do
  it { should be_directory }
  it { should exist }
  its('mode') { should cmp '00775' }
end

describe file("/opt/aem-helloworld-custom-stack-provisioner/#{component}-pre.txt") do
  it { should be_file }
  it { should exist }
  its('mode') { should cmp '00664' }
end
