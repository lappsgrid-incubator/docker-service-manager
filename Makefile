DOCKER=/usr/local/bin/docker
IMAGE=lappsgrid/service-manager
TARFILE=service-manager-vassar.tar


vassar:
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .

no-cache:
	$(DOCKER) build --no-cache -f Dockerfile.vassar -t $(IMAGE):vassar .

brandeis:
	$(DOCKER) build -f Dockerfile.brandeis -t $(IMAGE):brandeis .

latest:
	$(DOCKER) build -f Dockerfile.base -t $(IMAGE) .

all:
	$(DOCKER) build -f Dockerfile.base -t $(IMAGE):base .
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .
	$(DOCKER) build -f Dockerfile.brandeis -t $(IMAGE):brandeis .

run:
	$(DOCKER) run -d --name vassar -p 8080:8080 $(IMAGE):vassar

tag:
	if [ -n "$(TAG)" ] ; then $(DOCKER) $(IMAGE):vassar $(IMAGE):$(TAG) ; fi
	

upload:
	@echo "Saving container to a tar file."
	$(DOCKER) save -o $(TARFILE) $(IMAGE):vassar
	@echo "GZipping the tar file."
	gzip $(TARFILE)
	@echo "Uploading the gz file."
	scp -P 22022 $(TARFILE).gz suderman@anc.org:/home/www/anc/downloads/docker

push:
	$(DOCKER) push $(IMAGE):vassar

help:
	@echo
	@echo "    GOALS"
	@echo
	@echo "    vassar (default)"
	@echo "        Extends base with the GATE and Stanford services."
	@echo "    no-cache"
	@echo "        Builds the vassar image ignoring all cached layers."
	@echo "    base"
	@echo "        Builds a basic service manager with no services."
	@echo "    brandeis"
	@echo "        Extends base with the services from Brandies (OpenNLP et al)."
	@echo "    run"
	@echo "        Runs the $(IMAGE):vassar image"
	@echo "    push"
	@echo "        Pushes $(IMAGE) to the Docker Hub."
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

