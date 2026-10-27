version ?= 1.0.1-pre.0

ci: clean deps lint test package acceptance

# bundle install has no --binstubs option anymore in Bundler 4
deps:
	gem install bundler --version=4.0.22
	bundle install

# Gemfile.lock is committed and kept, so CI installs the pinned gems
clean:
	rm -rf .bundle/ bin/ stage/ log/ junit/

# The checks that don't need the bundle run first, as they are the quickest to fail.
# The file_ensure check (a Vox Pupuli plugin added since puppet-lint 2.3.6) is disabled, as its fix,
# ensure => file instead of present, would change what the manifests do when the path is a symlink.
# The exec_idempotency check is disabled too, as pre_common's auditd stopping runs on every apply by design
lint:
	shellcheck *.sh
	yamllint .yamllint.yaml .markdownlint.yaml .github/workflows/*.yaml spec/acceptance/nodesets/*.yml
	markdownlint-cli2 README.md
	python3 -m json.tool .rtk.json
	bundle exec puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		--no-file_ensure-check \
		--no-exec_idempotency-check \
		./modules/aem_helloworld/manifests/*.pp
	bundle exec puppet parser validate ./modules/aem_helloworld/manifests/*.pp
	bundle exec rubocop

# Catalog tests of the aem_helloworld classes with rspec-puppet
test:
	bundle exec rspec spec/classes

# Acceptance tests with Beaker on Docker: the package is unpacked and its pre-common.sh and post-common.sh run as
# packer-aem does, on every nodeset (beaker only runs one per invocation)
acceptance: package
	set -e; for nodeset in spec/acceptance/nodesets/*.yml; do \
		echo "== $$nodeset"; \
		BEAKER_SETFILE=$$nodeset bundle exec rspec spec/acceptance; \
	done

package:
	rm -rf stage
	mkdir -p stage
	tar \
	  -zcvf stage/aem-helloworld-custom-stack-provisioner-$(version).tar.gz \
	  --exclude="*.DS_Store" \
	  --exclude="./bin" \
	  --exclude="./stage" \
	  --exclude="./spec" \
	  --exclude="./log" \
	  --exclude="./junit" \
	  --exclude="./vendor" \
	  --exclude="*.idea*" \
	  --exclude="*.git*" \
	  --exclude="*.lock*" \
	  --exclude="*.bundle*" \
	  --exclude=".*.yml" \
	  --exclude=".*.yaml" \
	  --exclude="Gemfile" \
	  --exclude="Makefile" \
	  .

# Create the GitHub release and upload the package, run by the publish workflow on a pushed tag.
# safe.directory lets gh run git as root in the buildenv container
publish:
	GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=$(CURDIR) \
		gh release create $(version) --title $(version) --notes "" || echo "Release $(version) has been created on GitHub"
	GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=$(CURDIR) \
		gh release upload $(version) stage/aem-helloworld-custom-stack-provisioner-$(version).tar.gz

release-major:
	rtk release --release-increment-type major

release-minor:
	rtk release --release-increment-type minor

release-patch:
	rtk release --release-increment-type patch

release: release-minor

.PHONY: ci clean deps lint test acceptance package publish release release-major release-minor release-patch
