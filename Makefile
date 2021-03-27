
.PHONY: packer-build clean print_img_path print_box_name

include vars.mk

print_img_path:
	@echo $(UBUNTU_IMG_PATH)

print_box_name:
	@echo $(BOX_NAME)

print_box_version:
	@echo $(BOX_VERSION)

$(UBUNTU_IMG_PATH):
	vagrant box add \
	  --provider libvirt \
	  --box-version $(BASE_BOX_VERSION) \
	  $(BASE_BOX)

.ubuntu_checksum.md5: $(UBUNTU_IMG_PATH)
	cat $(UBUNTU_IMG_PATH) | pv | md5sum | awk '{ print $$1; }' > $@


# to work out the disk size:
# we need to run `qemu-img info /path/to/box.img`,
# and look for a line in the output that says:
#     virtual size: 128G (137438953472 bytes)
# or similar.

packer-build: output/vagrant_in_vagrant_0.0.1.box.md5 \
	            output/vagrant_in_vagrant_0.0.1.box \
	            output/vagrant_in_vagrant_0.0.1.qcow2

packer-test: packer-build
	./test-vm.sh


output/vagrant_in_vagrant_0.0.1.box.md5 \
output/vagrant_in_vagrant_0.0.1.box \
output/vagrant_in_vagrant_0.0.1.qcow2: $(UBUNTU_IMG_PATH) \
	                .ubuntu_checksum.md5 \
	                vagrant.d.tgz
	@if [ ! -f $(UBUNTU_IMG_PATH) ]; then \
	  printf 'no box.img found at %s!\n' $(UBUNTU_IMG_PATH); \
	  exit 1; \
	fi
	set -ex; \
	export PKR_VAR_UBUNTU_IMG_PATH=$(UBUNTU_IMG_PATH); \
	export PKR_VAR_DISK_SIZE=`qemu-img info $(UBUNTU_IMG_PATH) | grep '^virtual size' | sed 's/(//g' | awk '{ print $$4; }'`; \
	export PKR_VAR_DISK_CHECKSUM=`cat .ubuntu_checksum.md5`; \
	export PKR_VAR_BOX_VERSION=$(BOX_VERSION); \
	packer validate $(PACKER_FILE); \
	PACKER_LOG=1 packer build $(PACKER_FILE)

clean:
	-rm -rf \
    .ubuntu_checksum.md5 \
		output \
    packer_cache \
    vagrant.d.tgz

##
# targets to build vagrant plugin a docker container
##

DOCKER_IMG=phlummox/libvirt-plugin:0.1

docker-build:
	docker build -f Dockerfile -t $(DOCKER_IMG) .

# extract plugin .tgz from docker image
vagrant.d.tgz: docker-build
	set -ex; \
	container_id=`docker create $(DOCKER_IMG)`; \
	docker cp $$container_id:vagrant.d.tgz . ; \
	docker rm $$container_id

# may be useful for debugging
docker-run:
	docker -D run -it --rm  \
	    -v $$PWD:/opt/work \
	    $(DOCKER_IMG)

