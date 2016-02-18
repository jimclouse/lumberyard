SHELL = /bin/bash

default:
	sudo apt-get update
	sudo apt-get clean

	sudo apt-get -y install curl libcurl4-openssl-dev ruby ruby-dev make build-essential

	# Install Fluentd.
	export APT_SOURCES_FILE="treasure-data.list"
	echo "deb http://packages.treasure-data.com/precise/ precise contrib" > "/tmp/${APT_SOURCES_FILE}.tmp"
	sudo mv "/tmp/${APT_SOURCES_FILE}.tmp" "/etc/apt/sources.list.d/treasure-data.list"
	sudo apt-get update
	sudo apt-get install -y --force-yes libssl0.9.8 software-properties-common td-agent
	sudo apt-get clean
	export GEM_HOME="/usr/lib/fluent/ruby/lib/ruby/gems/1.9.1/"
	export GEM_PATH="/usr/lib/fluent/ruby/lib/ruby/gems/1.9.1/"
	export PATH="/usr/lib/fluent/ruby/bin:$PATH"

	sudo bash -c "GEM_HOME=/usr/lib/fluent/ruby/lib/ruby/gems/1.9.1/ && GEM_PATH=/usr/lib/fluent/ruby/lib/ruby/gems/1.9.1/ && PATH=/usr/lib/fluent/ruby/bin:\$PATH && \
	fluentd --setup=/etc/fluent && \
	"

	# Seriously, stop running...
	sudo /etc/init.d/td-agent stop
	sudo /etc/init.d/td-agent stop
	sudo rm /etc/init.d/td-agent

	# Copy fluentd config
	# ADD config/etc/fluent/fluent.conf /etc/td-agent/td-agent.conf
	# ADD config/etc/fluent/fluent.conf /etc/fluent/fluent.conf

	# install tds and python dependencies
	sudo apt-get -y install build-essential freetds-bin freetds-dev tdsodbc unixodbc unixodbc-dev python-pip
	sudo pip install pyodbc

	LOCALDIR=$(dirname "$0")

	# put odbcinst.ini in place
	sudo cp -f $LOCALDIR/../conf/odbcinst.ini /etc/
