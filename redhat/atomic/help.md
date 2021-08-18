= radondb-containers (1)
Radondb Data
December 23, 2019

== NAME
radondb-containers - Essential open source microservices for production PostgreSQL

== DESCRIPTION
The Radondb Container Suite provides the essential microservices for running a
enterprise-grade PostgreSQL cluster. These include:

- PostgreSQL
- PostGIS
- pgBackRest
- pgBouncer

and more.

== USAGE
For more information on the Radondb Container Suite, see the official
[Radondb Container Suite Documentation](https://access.radondb.com/documentation/radondb-containers/)

== LABELS
The starter container includes the following LABEL settings:

That atomic command runs the Docker command set in this label:

`Name=`

The registry location and name of the image. For example, Name="radondb/radondb-postgres".

`Version=`

The Red Hat Enterprise Linux version from which the container was built. For example, Version="7.7"

`Release=`

The specific release number of the container. For example, Release="4.7.1"
