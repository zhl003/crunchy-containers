ARG BASEOS
ARG BASEVER
ARG PG_FULL
ARG PREFIX
FROM ${PREFIX}/qingcloud-base:${BASEOS}-${PG_FULL}-${BASEVER}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG DFSET
ARG PACKAGER
ARG BASEOS
ARG PG_MAJOR

LABEL name="pgpool" \
	summary="Contains the pgpool utility as a PostgreSQL-aware load balancer" \
	description="Offers a smart load balancer in front of a Postgres cluster, sending writes only to the primary and reads to the replica(s). This allows an application to only have a single connection point when interacting with a Postgres cluster." \
	io.k8s.description="pgpool II" \
	io.k8s.display-name="pgpool II" \
	io.openshift.tags="postgresql,postgres,pgpool,database,qingcloud"

RUN ${PACKAGER} -y install \
		pgpool-II_${PG_MAJOR//.} \
		pgpool-II_${PG_MAJOR//.}-extensions \
	&& ${PACKAGER} -y clean all

# Preserving PGVERSION out of paranoia
ENV PGVERSION="${PG_MAJOR}"

RUN mkdir -p /opt/qingcloud/bin /opt/qingcloud/conf

ADD bin/pgpool /opt/qingcloud/bin
ADD bin/common /opt/qingcloud/bin
ADD conf/pgpool /opt/qingcloud/conf

RUN ln -sf /opt/qingcloud/conf/pool_hba.conf /etc/pgpool-II_${PG_MAJOR//.}/pool_hba.conf \
	&& ln -sf /opt/qingcloud/conf/pgpool/pool_passwd /etc/pgpool-II_${PG_MAJOR//.}/pool_passwd

RUN chgrp -R 0 /opt/qingcloud && \
	chmod -R g=u /opt/qingcloud


# open up the postgres port
EXPOSE 5432

# add volumes to allow override of pgpool config files
# The VOLUME directive must appear after all RUN directives to ensure the proper
# volume permissions are applied when building the image
VOLUME ["/pgconf"]

# Defines a unique directory name that will be utilized by the nss_wrapper in the UID script
ENV NSS_WRAPPER_SUBDIR="pgpool"

ENTRYPOINT ["opt/qingcloud/bin/uid_daemon.sh"]

USER 2

CMD ["/opt/qingcloud/bin/startpgpool.sh"]
