DOCKER=/usr/local/bin/docker
IMAGE=lappsgrid/service-manager
VERSION=1.0.0

manager:
	$(DOCKER) build -t $(IMAGE):$(VERSION) .

no-cache:
	$(DOCKER) build --no-cache -t $(IMAGE):$(VERSION) .

run:
	$(DOCKER) run -d --name manager -p 8080:8080 $(IMAGE):$(VERSION)

tag:
	if [ -n "$(TAG)" ] ; then $(DOCKER) tag $(IMAGE):$(VERSION) $(IMAGE):$(TAG) ; fi
	
push:
	$(DOCKER) push $(IMAGE):$(VERSION)

help:
	@echo
	@echo "    GOALS"
	@echo
	@echo "    manager (default)"
	@echo "        Extends base with the GATE and Stanford services."
	@echo "    no-cache"
	@echo "        Builds the vassar image ignoring all cached layers."
	@echo "    run"
	@echo "        Runs the $(IMAGE):$(VERSION) image"
	@echo "    push"
	@echo "        Pushes $(IMAGE):$(VERSION) to the Docker Hub."
	@echo "    both"
	@echo "        Builds both service_manager images."
	@echo "    all"
	@echo "        Builds both images and then pushes them."
	@echo "    tag TAG=<tag>"
	@echo "        Tags the vassar image on hub.docker.com. The tag"
	@echo "        to use must be specified on the command line."
	@echo "    help"
	@echo "        Prints these usage instructions."
	@echo

