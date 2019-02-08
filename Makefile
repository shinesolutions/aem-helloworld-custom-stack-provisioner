version ?= 0.9.0

ci: clean deps lint package

deps:
	gem install bundler
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

.PHONY: ci clean deps lint package
