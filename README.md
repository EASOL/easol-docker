## Introduction
This project's main objective is to make it easy for EASOL developers to set up a fresh new environment with a
working PHP/Nginx installation that is ready to connect to a MS SQL Server using [FreeTDS](http://www.freetds.org).

## Docker services
The project is composed of three different docker services, each one responsible for setting up and managing a single
process/server.

### Nginx
The `nginx` service is based on the official [nginx docker image](https://hub.docker.com/_/nginx/) and just defines
the default configuration for the web server.

The `site` folder is a mounted volume that points to the web server's document root, so you can add your own files
and they will be served by nginx.

### PHP-FPM
The `php` service also uses the official [php-fpm image from the docker hub](https://hub.docker.com/_/php/), but
additionally installs the [sybase_ct exension](http://php.net/manual/en/book.sybase.php), to make it possible to
communicate with MS SQL Server.

### Configuration
There's an additional service, `config`, that takes care of replacing all the configuration placeholders at runtime
and make the final values available to all involved docker containers.

It's basically a one-off process that reads the environment variables from `env.default` and replaces the
placeholders found in the `.conf` and `.ini` files with the actual values.

#### How can I override the default configuration?
The easiest way is by using the `env.local` file. Declare the environment variables that you want to override
by providing your own values, and the `config` container will pick them up instead of the default ones at runtime when
it performs the placeholder replacement.

## Installation
We provide an installation script that takes care of setting up all the required system dependencies, as well as the
docker tools.

These are the actual steps that are performed when the installation script runs:

* Install base packages for a proper development environment (git, curl, etc.)
* Install docker (unless it's already installed)
* Install docker compose (unless it's already installed)
* Clone this GIT repository and set proper defaults

*Note: The installation script is only compatible with Ubuntu.*

Here's how you can use it:

```
curl -sSL https://raw.githubusercontent.com/EASOL/easol-docker/master/install.sh | sudo bash
```

Some caveats:

* Make sure you have SSH access to this repository, otherwise the installation will fail when trying to clone it.
* Since this is a private repository, you'll probably have to add your credentials to the above URL, either by
providing your username & password or by appending a `token` query parameter.
* If you receive an error, try running again the `install.sh` script by providing the `--verbose` flag (or `-v` for
short). This will output all messages to the console, so you'll be able to actually see what went wrong.

## Usage
To orchestrate the three services and set up the containers we use [docker compose](https://docs.docker.com/compose/).
This allows us to declare in a single file, `docker-compose.yml`, the services involved as well as their relationships.

To start the three services, first make sure `docker-compose` is installed on your local machine and then run the
following command from the root of the project:

```
docker-compose up       # Add -d flag for “detached” mode
```

This will take care of building the docker images and starting three containers. If everything works as expected,
you should should see something similar to this:

```
Creating easoldocker_config_1
Creating easoldocker_php_1
Creating easoldocker_nginx_1
Attaching to easoldocker_config_1, easoldocker_php_1, easoldocker_nginx_1
config_1 | 2015/11/23 12:52:51 [ DEBUG ] Parsing environment references in '/etc/freetds/freetds.conf'
config_1 | 2015/11/23 12:52:51 [ DEBUG ] Expanding reference to 'TDS_HOST' to value 'ngbivv3p2g.database.windows.net'
config_1 | 2015/11/23 12:52:51 [ DEBUG ] Expanding reference to 'TDS_VERSION' to value 'auto'
config_1 | 2015/11/23 12:52:51 [ DEBUG ] Expanding reference to 'TDS_PORT' to value '1443'
php_1    | [23-Nov-2015 12:52:52] NOTICE: fpm is running, pid 1
php_1    | [23-Nov-2015 12:52:52] NOTICE: ready to handle connections
easoldocker_config_1 exited with code 0
```

This means you now have a working PHP + Nginx setup running on port 80 of your local host (or virtual machine if you use
docker machine). Press Control + C if you want to interrupt the server.

If you modify the `env.local` file, make sure you stop and destroy all previous containers, so the new values take
 effect, by issuing the following commands:

```
docker-compose stop     # Stops the containers
docker-compose rm -f    # Removes the containers
```

For more docker compose commands and options, please take a look at the
[official command line reference](http://docs.docker.com/compose/reference/docker-compose/).
