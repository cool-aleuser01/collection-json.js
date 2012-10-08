
DOCS = docs/*.md
HTMLDOCS = $(DOCS:.md=.html)
REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) --compilers coffee:coffee-script test/test.coffee

test-acceptance:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script --reporter $(REPORTER) \
		test/acceptance/integration.coffee

build:
	@mkdir -p build

build/collection-json.js: build
	@echo "Building bare"
	@./node_modules/browserify/bin/cmd.js \
		-o build/collection-json.js \
		-a 'underscore:/browser/underscore.coffee' \
		-r './browser/underscore' \
		-e browser/cj.bare.coffee
build/collection-json.min.js: build
	@echo "Minify bare"
	@./node_modules/.bin/uglifyjs \
		-o ./build/collection-json.min.js \
		./build/collection-json.js

build/collection-json.angular.js: build
	@echo "Building angular"
	@./node_modules/browserify/bin/cmd.js \
		-o build/collection-json.angular.js \
		-a 'underscore:/browser/underscore.coffee' \
		-r './browser/underscore' \
		-e browser/cj.angular.coffee
build/collection-json.angular.min.js: build
	@echo "Minify angular"
	@./node_modules/.bin/uglifyjs \
		-o ./build/collection-json.angular.min.js \
		./build/collection-json.angular.js

build/jquery.collection-json.js: build
	@echo "Building jquery"
	@./node_modules/browserify/bin/cmd.js \
		-o build/jquery.collection-json.js \
		-a 'underscore:/browser/underscore.coffee' \
		-r './browser/underscore' \
		-e browser/cj.jquery.coffee
build/jquery.collection-json.min.js: build
	@echo "Minify jquery"
	@./node_modules/.bin/uglifyjs \
		-o ./build/jquery.collection-json.min.js \
		./build/jquery.collection-json.js

client: build build/collection-json.js build/collection-json.min.js \
				build/collection-json.angular.js build/collection-json.angular.min.js\
				build/jquery.collection-json.js build/jquery.collection-json.min.js

.PHONY: test test-acceptance client
