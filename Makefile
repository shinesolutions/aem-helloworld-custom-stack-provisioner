version ?= 0.15.1-pre.0

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

publish:
	gh release create $(version) --title $(version) --notes "" || echo "Release $(version) has been created on GitHub"
	gh release upload $(version) stage/aem-helloworld-custom-stack-provisioner-$(version).tar.gz

release-major:
	rtk release --release-increment-type major

release-minor:
	rtk release --release-increment-type minor

release-patch:
	rtk release --release-increment-type patch

release: release-minor

.PHONY: ci clean deps lint package publish release release-major release-minor release-patch
