.PHONY: all
all: build run

.PHONY: build
build:
	docker image build -t generic-cv .

.PHONY: run
run: build
	docker container run --rm --interactive --tty --volume $(shell pwd)/..:/opt/gag/workspace generic-cv
