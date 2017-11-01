# Log Shippers Filebeat and Logspout for Logstash

These are a series of log shippers to use for *harvesting* log from the server and bring it to Logstash,
which in turn it will give it to Elasticsearch.

- **Logspout** - Read the log from Docker containers and send it to Logstash
- **Filebeat** - Read the log from log files and send it to Logstash


## Download Me!

Take this source from git repository with the following commands:

    $ git clone https://github.com/sangahco/docker-log-shippers.git
    $ cd docker-log-shippers
    $ git submodule init
    $ git submodule update


## Configurations available

- **docker-compose-prod.yml**

  Production configuration for log shippers.
  You should use this on the server where the web application is running, 
  in order to send logs to the ELK stack. `LOGSTASH_HOST` required.

- **docker-compose-dev.yml**

  The development configuration build the images before running them, 
  you still need to set `LOGSTASH_HOST` to point to the *Logstash* server.

- **docker-compose-dev2.yml**

  In case the [ELK stack](https://github.com/sangahco/docker-elk-stack) is running on the same server, 
  where you want to test these log shippers, is possible to use this configuration,
  with no need to set the `LOGSTASH_HOST` variable.

## Requirements

First make sure *Docker* and *Docker Compose* are installed on the machine with:

    $ docker -v
    $ docker-compose -v

If they are missing, follow the instructions on the official website (they are not hard really...):

- [Docker CE Install How-to](https://docs.docker.com/engine/installation/)
- [Docker Compose Install How-to](https://docs.docker.com/compose/install/)


## How to Use

Before starting the services make sure the variable `LOGSTASH_HOST` 
is set correctly to the right *Logstash* host machine.

**Use the script `docker-auto.sh` to manage these services!**

    $ ./docker-auto.sh --help


## Settings Up the Environment

The following settings are available:

| Variable     | Description                                                                                                                                         | Default  |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| REGISTRY_URL | This is the docker registry host where to publish the images                                                                                        |          |
| LOG_PATH     | Filebeat will harvest logs inside this folder                                                                                                       |          |
| LOG2_PATH    | Filebeat will harvest logs inside this folder                                                                                                       |          |
| LOG3_PATH    | Filebeat will harvest logs inside this folder                                                                                                       |          |
| LOG4_PATH    | Filebeat will harvest logs inside this folder                                                                                                       |          |
| LOG5_PATH    | Filebeat will harvest logs inside this folder                                                                                                       |          |
| FB_DATA_HOME | Filebeat data directory, where the log files states are stored,  it should be changed in production to a local directory                            | fbdata   |
| FB_TAGS      | Tags to send together with the log to logstash,  wrap the group with single quotation mark and separate them with comma ( ex. 'tag1, tag2, tag3' ). | filebeat |
| LOGSTASH_URL | Logstash host machine                                                                                                                               |          |

(\*) *table generated with [tablesgenerator](http://www.tablesgenerator.com/markdown_tables)*