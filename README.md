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
`
{"lumber":{"myTable":{"column1":"foobar", "column2":101}}}
`

## Why Would I Use It?
If you're like me, you don't want your OLTP database bogged down with audit and tracking information. With Lumberyard, you simply log audit and tracking data straight to your syslog and your data will be asynchronously stored in your audit database.

