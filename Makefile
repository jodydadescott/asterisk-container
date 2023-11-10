REGISTRY := jodydadescott
IMAGE := asterisk
TAG := latest

build:
	docker build -t $(REGISTRY)/$(IMAGE):$(TAG) .

push:
	docker push $(REGISTRY)/$(IMAGE):$(TAG)
