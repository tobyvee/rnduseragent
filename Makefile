MAKEFLAGS += --silent

# Default target to build the Docker image
.PHONY: all
all: 
	build

.PHONY: build
build:
	cd src && bash ./main.sh

.PHONY: clean
clean:
	rm -rf ./dist/*-useragent.sh && rm -f ./dist/latest

.PHONY: 
install:
	cd src && bash ./main.sh --install

.PHONY:
uninstall:
	rm -f /usr/local/bin/rnduseragent

.PHONY:
build-container:
	docker build -t rnduseragent .

.PHONY:
run-container: 
	docker run -it --rm rnduseragent

.PHONY:
clean-container:
	docker rmi rnduseragent

