# rnduseragent

`rnduseragent` is a small program written in bash that downloads the top 100 user agents from [https://github.com/microlinkhq/top-user-agents](https://github.com/microlinkhq/top-user-agents) and randomly selects one of them. 

The selected user agent is then printed to the standard output.

## Usage

```
Usage: $0 [options]
  -h, --help: Display this help message
  -v, --version: Display the version
  -i, --install: Install rnduseragent to /usr/local/bin
```

## Installation

### Local install - running locally

`rnduseragent` can be run locally on any unix-like system. The script is written in bash and requires `curl`, `jq`, `awk` and `make` to be installed on the system.

#### System requirements

- bash
- curl
- jq
- awk
- make

#### Installation

1. Clone the repository
2. Run `make build` in the repository root directory
3. Run `make build` in the repository root directory
4. The program is output to the `dist` directory. Inside this directory is a symlink name `latest` which always points to the latest version of the program.

#### Installing the program to the system $PATH

To install the program run `sudo make install` from the repository root directory. This will copy the program to `/usr/local/bin` and create a symlink to the latest version of the program.

### Container install

#### System requirements

- docker

#### Installation

1. From the repository root directory run `make build-container` to build the container
2. Run `make run-container` to run the container
3. *(optional)* Run `docker run -it --rm rnduseragent:latest` to run the container interactively
