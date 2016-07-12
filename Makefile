DOCKER=docker
IMAGE=lappsgrid/service-manager
TARFILE=service-manager-vassar.tar
TAG=discovery

# This is actually the main Service Manager Dockerfile, every thing is
# just badly named.  This target creates the image for the service manager
# and registers both the Vassar and Brandeis services.
latest:
	$(DOCKER) build -f Dockerfile.discovery -t $(IMAGE) .

vassar:
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .

no-cache:
	$(DOCKER) build --no-cache -f Dockerfile.vassar -t $(IMAGE):vassar .

brandeis:
	$(DOCKER) build -f Dockerfile.brandeis -t $(IMAGE):brandeis .

base:
	$(DOCKER) build -f Dockerfile.base -t $(IMAGE):base .

all:
	$(DOCKER) build -f Dockerfile.base -t $(IMAGE):base .
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .
	$(DOCKER) build -f Dockerfile.brandeis -t $(IMAGE):brandeis .

push:
	$(DOCKER) push $(IMAGE)
	
push-base:
	$(DOCKER) push $(IMAGE):base
	
run:
	$(DOCKER) run -d --name vassar -p 8080:8080 $(IMAGE):vassar

tag:
	if [ -n "$(TAG)" ] ; then $(DOCKER) tag $(IMAGE) $(IMAGE):$(TAG) ; fi
	
upload:
	@echo "Saving container to a tar file."
	$(DOCKER) save -o $(TARFILE) $(IMAGE):vassar
	@echo "GZipping the tar file."
	gzip $(TARFILE)
	@echo "Uploading the gz file."
	scp -P 22022 $(TARFILE).gz suderman@anc.org:/home/www/anc/downloads/docker

help:
	@echo
	@echo "    GOALS"
	@echo
	@echo "    latest (default)"
	@echo "        Builds the service manager image with Vassar and"
	@echo "        Brandeis services registered."
	@echo "    vassar"
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

