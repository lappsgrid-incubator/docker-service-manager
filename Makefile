DOCKER=/usr/local/bin/docker
IMAGE=lappsgrid/service-manager
TARFILE=service-manager-vassar.tar


vassar:
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .

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
	@echo "    help"
	@echo "        Prints these usage instructions."
	@echo

