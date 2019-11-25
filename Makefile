TAG=ashton314/program_builder

# Build a Docker image
.PHONY: docker-build
docker-build:
	docker build -t $(TAG) .

.PHONY: npm-compile
npm-compile:
	npm run deploy --prefix ./assets

.PHONY: manifest
manifest:
	mix phx.digest
