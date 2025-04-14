open_ios:
	$(MAKE) -C apple open

apple_graphql_gen:
	$(MAKE) -C apple graphql_gen

apple_extension_gen:
	$(MAKE) -C apple extension_gen

android_graphql_gen:
	cp packages/api/src/generated/schema.graphql android/Ruminer/app/src/main/graphql/schema.graphqls

droid:
	@if ! [ -e android/Ruminer/app/src/main/res/values/secrets.xml ]; then \
		cp android/Ruminer/secrets.xml android/Ruminer/app/src/main/res/values/secrets.xml; \
	fi
	studio android/Ruminer

webview_gen:
	yarn workspace @ruminer/appreader build
	cp packages/appreader/build/bundle.js apple/RuminerKit/Sources/Views/Resources/bundle.js
	cp packages/appreader/build/bundle.js android/Ruminer/app/src/main/assets/bundle.js

api:
	yarn workspace @ruminer/api dev

web:
	yarn workspace @ruminer/web dev

qp:
	yarn workspace @ruminer/api dev_qp

content_handler:
	yarn workspace @ruminer/content-handler build

puppeteer:
	yarn workspace @ruminer/puppeteer-parse build

content_fetch: content_handler puppeteer
	yarn workspace @ruminer/content-fetch build
	yarn workspace @ruminer/content-fetch start
