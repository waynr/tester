IMAGE_NAME ?= nanzhong/tester
COMMIT ?= $(shell git rev-parse HEAD)

.PHONY: all
all: tester

.PHONY: clean
clean:
	rm -rf dist
	rm -rf ./cmd/tester/pkged.go

.PHONY: install
install:
	pkger -o ./cmd/tester
	go install ./cmd/tester/...

.PHONY: tester
tester:
	pkger -o ./cmd/tester
	GOOS=linux GOARCH=amd64 go build -o ./dist/tester-linux-amd64 ./cmd/tester/...
	docker build -t $(IMAGE_NAME):$(COMMIT) .
ifdef LATEST
	docker tag $(IMAGE_NAME):$(COMMIT) $(IMAGE_NAME):latest
endif
ifdef PUSH
	docker push $(IMAGE_NAME):$(COMMIT)
ifdef LATEST
	docker push $(IMAGE_NAME):latest
endif
endif
