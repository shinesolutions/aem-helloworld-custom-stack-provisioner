# frozen_string_literal: true

# The component fact is read with the facter command, as Cinc InSpec 7 can't load the facter gem
# (facter 4 needs thor < 1.3, Cinc InSpec 7 ships thor 1.4)
component = command('/opt/puppetlabs/bin/facter component').stdout.strip

describe file('/opt/aem-helloworld-custom-stack-provisioner/') do
  it { should be_directory }
  it { should exist }
  its('mode') { should cmp '00775' }
end

describe file("/opt/aem-helloworld-custom-stack-provisioner/#{component}-post.txt") do
  it { should be_file }
  it { should exist }
  its('mode') { should cmp '00664' }
end
