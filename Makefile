#
SHELL = /bin/bash

# Installs and configures Freetds
default:
	@if [ "$(NODE_ENV)" == "production" ]; then\
		sudo apt-get update;\
		sudo apt-get install -y build-essential freetds-bin freetds-dev tdsodbc unixodbc;\
		sudo cp -f ./freetds.conf /etc/freetds/;\
	fi

	@if [ "$(NODE_ENV)" == "development" ]; then\
		brew list unixodbc &>/dev/null || brew install unixodbc;\
	fi
