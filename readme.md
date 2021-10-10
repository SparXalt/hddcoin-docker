# unOfficial HDDcoin Docker Container

## Quick Start

These examples shows valid setups using HDDcoin for both docker run and docker-compose. Note that you should read some documentation at some point, but this is a good place to start.

### Docker run

```bash
docker run --name hddcoin -d ghcr.io/sparxalt/hddcoin-docker:latest --expose=28444 -v /path/to/plots:/plots
```
Syntax
```bash
docker run --name <container-name> -d ghcr.io/sparxalt/hddcoin-docker:latest 
optional accept incoming connections: --expose=28444
optional: -v /path/to/plots:/plots
```

### Docker compose

```yaml
version: "3.6"
services:
  hddcoin:
    container_name: hddcoin
    restart: unless-stopped
    image: ghcr.io/sparxalt/hddcoin-docker:latest
    ports:
      - 28444:28444
    volumes:
      - /path/to/plots:/plots
```

## Configuration

You can modify the behavior of your HDDcoin container by setting specific environment variables.

### Timezone

Set the timezone for the container (optional, defaults to UTC).
Timezones can be configured using the `TZ` env variable. A list of supported time zones can be found [here](http://manpages.ubuntu.com/manpages/focal/man3/DateTime::TimeZone::Catalog.3pm.html)
```bash
-e TZ="America/Chicago"
```

### Add your custom keys

To use your own keys pass as arguments on startup (post 1.0.2 pre 1.0.2 must manually pass as shown below)
```bash
-v /path/to/key/file:/path/in/container -e keys="/path/in/container"
```
or pass keys into the running container
```bash
docker exec -it <container-name> venv/bin/hddcoin keys add
```
alternatively you can pass in your local keychain, if you have previously deployed hddcoin with these keys on the host machine
```bash
-v ~/.local/share/python_keyring/:/root/.local/share/python_keyring/
```
or if you would like to persist the entire mainnet subdirectory and not touch the key directories at all
```bash
-v ~/.hddcoin/mainnet:/root/.hddcoin/mainnet -e keys="persistent"
```


### Persist configuration and db

You can persist whole db and configuration, simply mount it to Host.
```bash
-v ~/.hddcoin:/root/.hddcoin
```

### Farmer only

To start a farmer only node pass
```bash
-e farmer="true"
```

### Harverster only

To start a harvester only node pass
```bash
-e harvester="true" -e farmer_address="addres.of.farmer" -e farmer_port="portnumber" -v /path/to/ssl/ca:/path/in/container -e ca="/path/in/container" -e keys="copy"
```

### Plots

The `plots_dir` environment variable can be used to specify the directory containing the plots, it supports PATH-style colon-separated directories.

Or, you can cimply mount `/plots` path to your host machine.

### Log level
To set the log level to one of CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
```bash
-e log_level="DEBUG"
```

### Docker Compose

```yaml
version: "3.6"
services:
  hddcoin:
    container_name: hddcoin
    restart: unless-stopped
    image: ghcr.io/sparxalt/hddcoin-docker:latest
    ports:
      - 28444:28444
    environment:
      # Farmer Only    
#     - farmer=true
      # Harvester Only
#     - harvester=true
#     - farmer_address=192.168.0.10 
#     - farmer_port=8447
#     - ca=/path/in/container
#     - keys=copy
      # Harvester Only END
      # If you would like to add keys manually via mnemonic file
#     - keys=/path/in/container
      # OR
      # Disable key generation on start
#     - keys=
      - TZ=${TZ}
    volumes:
      - /path/to/plots:/plots
      - /home/user/.hddcoin:/root/.hddcoin
#     - /home/user/mnemonic:/path/in/container
```

## CLI

You can run commands externally with venv (this works for most hddcoin [CLI commands](https://github.com/HDDcoin-Network/hddcoin-blockchain/wiki/CLI-Commands-Reference))
```bash
docker exec -it hddcoin venv/bin/hddcoin plots add -d /plots
```

### Is it working?

You can see status from outside the container
```bash
docker exec -it hddcoin venv/bin/hddcoin show -s -c
```
or
```bash
docker exec -it hddcoin venv/bin/hddcoin farm summary
```

### Connect to testnet?

```bash
docker run -d --expose=48444 -e testnet=true --name hddcoin ghcr.io/sparxalt/hddcoin-docker:latest
```

#### Need a wallet?

To get new wallet, execute command and follow the prompts:

```bash
docker exec -it hddcoin-farmer1 venv/bin/hddcoin wallet show
```

## Building

```bash
docker build -t hddcoin --build-arg BRANCH=latest .
```
