accumulo-jmxtrans-ganglia
=========================

Support scripts to get [Accumulo](http://accumulo.apache.org/) metrics into [Ganglia](http://ganglia.sourceforge.net/) using [jmxtrans](https://github.com/jmxtrans/jmxtrans).

Required
--------

These scripts assume a fair bit about the environment:

* you have root
* you have Ganglia gmetad installed on a "monitoring" host
* you have Ganglia gmond installed on the tablet servers
* you have Accumulo installed on the Ganglia monitoring host
* you have key-based authentication to all tablet servers
* you have downloaded the jmxtrans RPM

Instructions
------------

On the Ganglia monitoring server:

1.  Grab the .json files and install_jmxtrans script, place into a directory.

2.  In *install_jmxtrans* set ACCUMULO_HOME, JMXTRANS_RPM, and GANGLIA_MONITOR

3.  On a system with Accumulo installed, run *install_jmxtrans*.

Thanks
------

Props to Miguel Pereira for posting his examples to [accumulo-dev](http://mail-archives.apache.org/mod_mbox/accumulo-dev/201208.mbox/%3CCAPCL_BzamRqqGLTCb=6R_5u+hFZ=EgapbnrrueM-xb8-0Ax86A@mail.gmail.com%3E) last year.

License
-------

This project is provided under the Apache Software License 2.0. See the file `LICENSE` for more information.
