DOCKER=/usr/bin/docker
IMAGE=lappsgrid/service-manager
TARFILE=service-manager-vassar.tar

help:
	@echo
	@echo "    GOALS"
	@echo
	@echo "    base"
	@echo "        Builds a basic service manager with no services."
	@echo
	@echo "    vassar"
	@echo "        Extends base with the GATE and Stanford services."
	@echo
	@echo "    brandeis"
	@echo "        Extends base with the services from Brandies (OpenNLP et al)."
	@echo
	@echo "    run"
	@echo "        Runs the $(IMAGE):vassar image"
	@echo
	@echo "    push"
	@echo "        Pushes $(IMAGE) to the Docker Hub."
	@echo
	@echo "    both"
	@echo "        Builds both service_manager images."
	@echo
	@echo "    all"
	@echo "        Builds both images and then pushes them."
	@echo	    	
	@echo "    help"
	@echo "        Prints these usage instructions."
	@echo

base:
	$(DOCKER) build -f Dockerfile.base -t $(IMAGE) .

vassar:
	$(DOCKER) build -f Dockerfile.vassar -t $(IMAGE):vassar .

brandeis:
	$(DOCKER) build -f Dockerfile.brandeis -t $(IMAGE):brandeis .

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
	$(DOCKER) push $(IMAGE):all

