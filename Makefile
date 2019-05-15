version ?= 0.10.0-pre.0

ci: clean deps lint package

deps:
	gem install bundler --version=1.17.3
	bundle install --binstubs

clean:
	rm -rf .bundle/ bin/ stage/ *.lock

lint:
	bundle exec puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		./modules/aem_helloworld/manifests/*.pp
	bundle exec rubocop
	shellcheck *.sh

package: clean
	mkdir -p stage
	tar \
	  -zcvf stage/aem-helloworld-custom-stack-provisioner-$(version).tar.gz \
    --exclude="*.DS_Store" \
    --exclude="*bin*" \
    --exclude="*stage*" \
    --exclude="*.idea*" \
    --exclude="*.git*" \
		--exclude="*.lock*" \
    --exclude="*.bundle*" \
    --exclude=".*.yml" \
		--exclude="Gemfile" \
		--exclude="Makefile" \
	  .

release:
	rtk release

.PHONY: ci clean deps lint package release
