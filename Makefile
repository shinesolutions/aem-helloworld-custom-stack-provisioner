version ?= 0.9.0

ci: clean deps lint package

deps:
	gem install bundler
	bundle install --binstubs

clean:
	rm -rf bin/ stage/ *.lock

lint:
	bundle exec puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		./modules/aem_helloworld/*.pp

package: clean
	mkdir -p stage
	zip -r \
	    -x "*.DS_Store" \
	    -x "*bin*" \
	    -x "*stage*" \
	    -x "*.idea*" \
	    -x "*.git*" \
	    -X "stage/aem-helloworld-custom-stack-provisioner-$(version).zip" *

.PHONY: ci clean deps lint package
