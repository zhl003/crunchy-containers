ARG BASEOS
ARG BASEVER
ARG PG_FULL
ARG PREFIX
FROM ${PREFIX}/radondb-base:${BASEOS}-${PG_FULL}-${BASEVER}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG DFSET
ARG PACKAGER

ARG PG_MAJOR

LABEL name="pgbouncer" \
	summary="Lightweight connection pooler for radondb-postgres" \
	description="The aim of radondb-pgbouncer is to lower the performance impact of opening new connections to PostgreSQL; clients connect through this service. It offers session, transaction and statement pooling." \
	io.k8s.description="pgBouncer" \
	io.k8s.display-name="pgBouncer" \
	io.openshift.tags="postgresql,postgres,pooling,pgbouncer,database,radondb"

RUN ${PACKAGER} -y install --nodocs \
	--disablerepo="epel" \
	pgbouncer \
	&& ${PACKAGER} -y clean all

# Preserving PGVERSION out of paranoia
ENV PGVERSION="${PG_MAJOR}"

RUN mkdir -p /opt/radondb/bin /opt/radondb/conf /pgconf

ADD bin/pgbouncer /opt/radondb/bin
ADD bin/common /opt/radondb/bin
ADD conf/pgbouncer /opt/radondb/conf

RUN chown -R 2:0 /opt/radondb /pgconf && \
	chmod -R g=u /opt/radondb /pgconf

EXPOSE 6432

# The VOLUME directive must appear after all RUN directives to ensure the proper
# volume permissions are applied when building the image
VOLUME ["/pgconf"]

# Defines a unique directory name that will be utilized by the nss_wrapper in the UID script
ENV NSS_WRAPPER_SUBDIR="pgbouncer"

ENTRYPOINT ["opt/radondb/bin/uid_daemon.sh"]

USER 2

CMD ["/opt/radondb/bin/start.sh"]
