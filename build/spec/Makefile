### ==== CONFIG ====
generator := typescript-node
openapi-generator-version := 5.4.0
openapi-generator-url := https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$(openapi-generator-version)/openapi-generator-cli-$(openapi-generator-version).jar
openapi-generator-jar := build/openapi-generator-cli.jar
openapi-generator-cli := java -jar $(openapi-generator-jar)

specs_dir := build/spec/json

multiFileServices := checkout management payout balancePlatform legalEntityManagement transfers
singleFileServices := balanceControl disputes payment recurring binLookup storedValue terminalManagement dataProtection

specs := \
  checkout=CheckoutService-v71 \
  management=ManagementService-v3 \
  payout=PayoutService-v68 \
  balancePlatform=BalancePlatformService-v2 \
  legalEntityManagement=LegalEntityService-v3 \
  transfers=TransferService-v4 \
  balanceControl=BalanceControlService-v1 \
  disputes=DisputeService-v30 \
  payment=PaymentService-v68 \
  recurring=RecurringService-v68 \
  binLookup=BinLookupService-v54 \
  storedValue=StoredValueService-v46 \
  terminalManagement=TfmAPIService-v1 \
  dataProtection=DataProtectionService-v1

spec = $(shell echo $(specs) | tr ' ' '\n' | grep ^$@= | cut -d= -f2)

### ==== TASKS ====

all: build/spec $(openapi-generator-jar) models services

clean:
	rm -rf build src/typings/* src/services/*

build/spec:
	mkdir -p build
	git clone https://github.com/Adyen/adyen-openapi.git build/spec
	perl -i -pe 's/"openapi" : "3\.[0-9]\.[0-9]"/"openapi" : "3.0.0"/' $(specs_dir)/*.json

$(openapi-generator-jar):
	mkdir -p build
	wget --quiet -O $(openapi-generator-jar) $(openapi-generator-url)

models: $(multiFileServices) $(singleFileServices)

services: $(multiFileServices) $(singleFileServices)

$(multiFileServices): build/spec $(openapi-generator-jar)
	@echo "Generating multi-file service: $@"
	rm -rf build/model src/typings/$@ src/services/$@
	$(openapi-generator-cli) generate \
		-i $(specs_dir)/$(spec).json \
		-g $(generator) \
		-t templates/typescript \
		-o build \
		-c templates/config.yaml \
		--skip-validate-spec \
		--api-package $@ \
		--api-name-suffix Service \
		--global-property models,apis,supportingFiles \
		--additional-properties=modelPropertyNaming=original \
		--additional-properties=serviceName=$@
	mkdir -p src/services/$@
	mv build/$@/*Api.ts src/services/$@/ || true
	mv build/index.ts src/services/$@/ || true
	mv -f build/model src/typings/$@ || true
	npx eslint --fix ./src/services/$@/*.ts || true
	npx prettier --write ./src/services/$@/*.ts || true

$(singleFileServices): build/spec $(openapi-generator-jar)
	@echo "Generating single-file service: $@"
	rm -rf src/typings/$@ build/model src/services/$@Api.ts
	jq -e 'del(.paths[][].tags)' $(specs_dir)/$(spec).json > $(specs_dir)/$(spec).tmp
	mv $(specs_dir)/$(spec).tmp $(specs_dir)/$(spec).json
	$(openapi-generator-cli) generate \
		-i $(specs_dir)/$(spec).json \
		-g $(generator) \
		-o build \
		-c templates/config.yaml \
		--skip-validate-spec \
		--api-package $@ \
		--api-name-suffix Service \
		--global-property models,apis,supportingFiles \
		--additional-properties=modelPropertyNaming=original \
		--additional-properties=serviceName=$@
	mkdir -p src/services
	mv build/$@/*Root.ts src/services/$@Api.ts || true
	mv -f build/model src/typings/$@ || true
	npx eslint --fix ./src/services/$@Api.ts || true
	npx prettier --write ./src/services/$@Api.ts || true

.PHONY: all clean models services $(multiFileServices) $(singleFileServices)
