#!/usr/bin/env bash

{ # this ensures the entire script is downloaded

DOCKER_APT_REPO_URL="https://apt.dockerproject.org/repo"
COMPOSE_INSTALL_URL="https://github.com/docker/compose/releases/download/1.5.1/docker-compose-$(uname -s)-$(uname -m)"
GIT_REPO_URL="git@github.com:EASOL/easol-docker.git"

command_exists() {
  type "$1" > /dev/null 2>&1
}

check_options() {
    case $1 in
    '--verbose' | '-v')
        verbose=1
        ;;
    '--help' | '-h')
        echo "Usage: install.sh [--verbose | -v][--help | -h]"
        exit 0
        ;;
    esac
}

run_cmd() {
    if [ -n "$verbose" ]; then
        "$@"
    else
        "$@" > /dev/null 2>&1
    fi
}

is_ubuntu() {
    command_exists lsb_release && [ "$(lsb_release -si)" == "Ubuntu" ]
}

raise_error() {
    tput setaf 1
    echo "error!"
cat >&2 <<-'EOF'
A problem ocurred while performing some of the installation steps. Please run the install script again with
the '--verbose' option to debug the problem.
EOF
    tput sgr0
    exit 1
}

install_base_packages() {
    echo -n "Installing required system packages..."
    run_cmd apt-get install -y git curl
    echo "done!"
}

install_docker() {
    echo -n "Installing docker..."
    if ! command_exists docker; then
        dist_version="$(lsb_release --codename | cut -f2)"
        # Configure APT source
        run_cmd apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        echo "deb $DOCKER_APT_REPO_URL ubuntu-$dist_version main" > /etc/apt/sources.list.d/docker.list
        # Install packages
        run_cmd apt-get update
        run_cmd apt-get purge -y lxc-docker
        run_cmd apt-get install -y linux-image-extra-$(uname -r) docker-engine
        # Test docker installation
        if command_exists docker; then
            echo "done!"
        else
            raise_error
        fi
    else
        echo "already installed, skipping"
    fi
}

install_compose() {
    echo -n "Installing docker compose..."
    if ! command_exists docker-compose; then
        curl -Ls $COMPOSE_INSTALL_URL > /usr/local/bin/docker-compose
        run_cmd chmod +x /usr/local/bin/docker-compose
        # Test docker-compose installation
        if command_exists docker-compose; then
            echo "done!"
        else
            raise_error
        fi
    else
        echo "already installed, skipping"
    fi
}

setup_project() {
    echo -n "Cloning EASOL docker project into $(pwd)..."
    run_cmd git clone $GIT_REPO_URL
    if [ -d "easol-docker" ]; then
        # Don't track changes in the env.local file
        cd easol-docker
        run_cmd git update-index --assume-unchanged env.local
        echo "done!"
    else
        raise_error
    fi
}

display_post_install_message() {
    tput setaf 2
    echo "Install is complete. You can now run 'docker-compose up' to start the EASOL services"
    tput sgr0
}

# Check script parameters
check_options $1

if is_ubuntu; then
    install_base_packages
    install_docker
    install_compose
    setup_project
    display_post_install_message
    exit 0
else
    tput setaf 1
    echo "Sorry, this install script is not compatible with your operating system" >&2
    tput sgr 0
    exit 1
fi

} # this ensures the entire script is downloaded
