# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'the custom stack provisioner steps' do
  %w[pre post].each do |step|
    context "with #{step}-common.sh" do
      # The scripts exit non-zero when puppet apply or the InSpec test fails
      it 'runs the Puppet manifest and its InSpec test' do
        expect(run_step(step, 'author').stdout).to include('for component author')
      end

      describe file("/opt/aem-helloworld-custom-stack-provisioner/author-#{step}.txt") do
        it { is_expected.to be_file }
        it { is_expected.to be_mode 664 }
      end
    end
  end
end
