ARG BASEOS
ARG BASEVER
ARG PG_FULL
ARG PREFIX
FROM ${PREFIX}/qingcloud-base:${BASEOS}-${PG_FULL}-${BASEVER}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG DFSET
ARG PACKAGER

ARG PG_MAJOR

LABEL name="pgbouncer" \
	summary="Lightweight connection pooler for qingcloud-postgres" \
	description="The aim of qingcloud-pgbouncer is to lower the performance impact of opening new connections to PostgreSQL; clients connect through this service. It offers session, transaction and statement pooling." \
	io.k8s.description="pgBouncer" \
	io.k8s.display-name="pgBouncer" \
	io.openshift.tags="postgresql,postgres,pooling,pgbouncer,database,qingcloud"

RUN ${PACKAGER} -y install \
	--disablerepo="epel" \
	pgbouncer \
	&& ${PACKAGER} -y clean all

# Preserving PGVERSION out of paranoia
ENV PGVERSION="${PG_MAJOR}"

RUN mkdir -p /opt/qingcloud/bin /opt/qingcloud/conf /pgconf

ADD bin/pgbouncer /opt/qingcloud/bin
ADD bin/common /opt/qingcloud/bin
ADD conf/pgbouncer /opt/qingcloud/conf

RUN chown -R 2:0 /opt/qingcloud /pgconf && \
	chmod -R g=u /opt/qingcloud /pgconf

EXPOSE 6432

# The VOLUME directive must appear after all RUN directives to ensure the proper
# volume permissions are applied when building the image
VOLUME ["/pgconf"]

# Defines a unique directory name that will be utilized by the nss_wrapper in the UID script
ENV NSS_WRAPPER_SUBDIR="pgbouncer"

ENTRYPOINT ["opt/qingcloud/bin/uid_daemon.sh"]

USER 2

CMD ["/opt/qingcloud/bin/start.sh"]
