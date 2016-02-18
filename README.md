#Lumberyard
---------------
## What Is It?
Lumberyard is a fluentd plugin of sorts. 
Technically it's just a set of fluentd configurations and a program run by the built-in exec output plugin.

## What Does It Do?
Lumberyard takes specifically formatted log messages and inserts them into a relational database.

## What Format Must I Use?
Lumberyard only accepts valid json messages that begin with the lumber attribute. The inner json consists of a table name and an object with column name and value key pairs. 

For example:
```
{"lumber":{"myTable":{"column1":"foobar", "column2":101}}}
```

## Why Would I Use It?
If you're like me, you don't want your OLTP database bogged down with audit and tracking information. With Lumberyard, you simply log audit and tracking data straight to your syslog and your data will be asynchronously stored in your audit database.

## Installation

### Dependenceis
* MSSQL Server
* Linux Server for fluentd **Installation has only been tested on Ubuntu 14.04 Trusty 

### Environment Variables
Lumberyard expects SQL connection information to be available via environment variables.<br>
Save these variables to a file and source it
```
export LUMBERYARD_SERVER=xxxxxxxx:
export LUMBERYARD_DB=xxxxxxxx
export LUMBERYARD_USER=xxxxxxxx
export LUMBERYARD_PASSWORD=xxxxxxxx
```

### Full install of fluentd w/Lumberyard
This will install fluentd, freetds, and the python tools needed
* from /home/ubuntu** clone this repo
* cd into Lumberyard
* run `make full`
 
### I've Already Got fluentd Installed
Installation is much more manual for you
* From /home/ubuntu** clone this repo
* cd into Lumberyard
* run `make partial`
* Find and open your fluentd config file for editing
* I assume you already have a `<source>` section in your config, if not, see `Lumberyard/fluent.config`.
* Your fluentd config must use `type copy` to allow logs to forward to multiple destinations, assuming you already have a destination set up.
* Copy the `<store>` tag in `Lumberyard/fluent.config` into your fluentd config
* Restart your fluentd
