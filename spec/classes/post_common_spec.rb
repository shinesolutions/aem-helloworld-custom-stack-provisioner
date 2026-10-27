# frozen_string_literal: true

require 'spec_helper'

describe 'aem_helloworld::post_common' do
  on_supported_os(supported_os).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(component: 'author') }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_notify('Display status message with component name').with_message(/for component author$/) }
      it { is_expected.to contain_file('/opt/aem-helloworld-custom-stack-provisioner/').with(ensure: 'directory', mode: '0775') }
      it { is_expected.to contain_file('/opt/aem-helloworld-custom-stack-provisioner/author-post.txt').with(ensure: 'present', mode: '0664') }
    end
  end
end
