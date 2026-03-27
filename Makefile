### ==== CONFIG ====
generator := typescript-node
openapi_generator_version := 5.4.0
openapi_generator_url := https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$(openapi_generator_version)/openapi-generator-cli-$(openapi_generator_version).jar
openapi_generator_jar := build/openapi-generator-cli.jar
openapi_generator_cli := java -jar $(openapi_generator_jar)

specs_dir := build/spec/json

# Services that generate multiple API files
multiFileServices := checkout management payout balancePlatform legalEntityManagement transfers

# Services that generate a single root API file
singleFileServices := balanceControl disputes payment recurring binLookup storedValue terminalManagement dataProtection

# Webhooks / typings-only services
modelOnlyServices := acsWebhooks configurationWebhooks reportWebhooks transferWebhooks transactionWebhooks managementWebhooks

allServices := $(multiFileServices) $(singleFileServices) $(modelOnlyServices)

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
  dataProtection=DataProtectionService-v1 \
  acsWebhooks=BalancePlatformAcsNotification-v1 \
  configurationWebhooks=BalancePlatformConfigurationNotification-v1 \
  reportWebhooks=BalancePlatformReportNotification-v1 \
  transferWebhooks=BalancePlatformTransferNotification-v4 \
  transactionWebhooks=BalancePlatformTransactionNotification-v4 \
  managementWebhooks=ManagementNotificationService-v3

spec = $(shell echo $(specs) | tr ' ' '\n' | grep '^$@=' | cut -d= -f2)

### ==== TASKS ====

.PHONY: all clean models services templates $(allServices)

all: build/spec $(openapi_generator_jar) models services

clean:
	rm -rf build src/typings/* src/services/*

### ==== SETUP ====

build/spec:
	mkdir -p build
	if [ ! -d build/spec ]; then \
		git clone https://github.com/Adyen/adyen-openapi.git build/spec; \
	fi
	perl -i -pe 's/"openapi" : "3\.[0-9]\.[0-9]"/"openapi" : "3.0.0"/' $(specs_dir)/*.json

$(openapi_generator_jar):
	mkdir -p build
	wget --quiet -O $(openapi_generator_jar) $(openapi_generator_url)

templates: $(openapi_generator_jar)
	$(openapi_generator_cli) author template -g $(generator) -o build/templates/typescript

### ==== ENTRYPOINTS ====

models: $(allServices)

services: $(multiFileServices) $(singleFileServices)

### ==== MODEL-ONLY GENERATION ====

$(modelOnlyServices): build/spec $(openapi_generator_jar)
	@echo "Generating model-only service: $@"
	rm -rf src/typings/$@ build/model
	$(openapi_generator_cli) generate \
		-i $(specs_dir)/$(spec).json \
		-g $(generator) \
		-t templates/typescript \
		-o build \
		--skip-validate-spec \
		--global-property models,supportingFiles \
		--additional-properties=serviceName=$@ \
		--additional-properties=modelPropertyNaming=original
	mkdir -p src/typings
	mv build/model src/typings/$@ || true

### ==== MULTI-FILE SERVICE GENERATION ====

$(multiFileServices): build/spec $(openapi_generator_jar)
	@echo "Generating multi-file service: $@"
	rm -rf build/model src/typings/$@ src/services/$@
	$(openapi_generator_cli) generate \
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
	mv build/model src/typings/$@ || true
	npx eslint --fix ./src/services/$@/*.ts || true
	npx prettier --write ./src/services/$@/*.ts || true

### ==== SINGLE-FILE SERVICE GENERATION ====

$(singleFileServices): build/spec $(openapi_generator_jar)
	@echo "Generating single-file service: $@"
	rm -rf src/typings/$@ build/model src/services/$@Api.ts
	jq -e 'del(.paths[][].tags)' $(specs_dir)/$(spec).json > $(specs_dir)/$(spec).tmp
	mv $(specs_dir)/$(spec).tmp $(specs_dir)/$(spec).json
	$(openapi_generator_cli) generate \
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
	mkdir -p src/services src/typings
	mv build/$@/*Root.ts src/services/$@Api.ts || true
	mv build/model src/typings/$@ || true
	npx eslint --fix ./src/services/$@Api.ts || true
	npx prettier --write ./src/services/$@Api.ts || true
