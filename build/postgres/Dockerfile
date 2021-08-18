ARG BASEOS
ARG BASEVER
ARG PG_FULL
ARG PREFIX
ARG BASE_IMAGE_NAME
FROM ${PREFIX}/${BASE_IMAGE_NAME}:${BASEOS}-${PG_FULL}-${BASEVER}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG PG_FULL
ARG BASEOS
ARG DFSET
ARG PACKAGER

# ===== Early lines ordered for leveraging cache, reorder carefully =====
ARG PG_MAJOR
# Needed due to lack of environment substitution trick on ADD
ARG PG_LBL

RUN ${PACKAGER} -y install \
	--disablerepo=radondbpg* \
	--enablerepo="radondbpg${PG_LBL}" \
	postgresql${PG_LBL} \
 && ${PACKAGER} -y clean all

# Preserving PGVERSION out of paranoia
ENV PGROOT="/usr/pgsql-${PG_MAJOR}" PGVERSION="${PG_MAJOR}"

ARG BACKREST_VER

# Separate yum run matching postgres-ha image, leverages cached layer
RUN if [ "$DFSET" = "centos" ] ; then \
        ${PACKAGER} -y install \
        	--setopt=skip_missing_names_on_install=False \
        	openssh-clients \
        	openssh-server \
        	pgaudit${PG_MAJOR//.} \
        	pgaudit${PG_MAJOR//.}_set_user \
        	pg_partman_${PG_MAJOR//.} \
        	pg_cron_${PG_MAJOR//.} \
        	radondb-backrest-${BACKREST_VER} \
        	postgresql${PG_MAJOR//.}-contrib \
        	postgresql${PG_MAJOR//.}-server \
        	postgresql${PG_MAJOR//.}-plpython* \
        	pgnodemx${PG_MAJOR//.} \
        	$( printf '11\n'${PG_MAJOR} | sort -VC && echo postgresql${PG_MAJOR}-llvmjit ) \
        	psmisc \
        	rsync \
        	$( printf '11\n'${PG_MAJOR} | sort -VC && echo timescaledb_${PG_MAJOR} ) \
        	wal2json${PG_MAJOR//.} \
        	file \
        	gettext \
        	hostname \
        	procps-ng \
        	pgaudit_analyze \
        	unzip \
        	bzip2 \
        	lz4 \
        && ${PACKAGER} -y clean all ; \
else \
        ${PACKAGER} -y install \
		--enablerepo="epel" \
		openssh-clients \
		openssh-server \
		pgaudit${PG_MAJOR//.} \
		pgaudit${PG_MAJOR//.}_set_user \
		pg_partman_${PG_MAJOR//.} \
		pg_cron_${PG_MAJOR//.} \
		radondb-backrest-${BACKREST_VER} \
		postgresql${PG_MAJOR//.}-contrib \
		postgresql${PG_MAJOR//.}-server \
		postgresql${PG_MAJOR//.}-plpython* \
		pgnodemx${PG_MAJOR//.} \
		$( printf '11\n'${PG_MAJOR} | sort -VC && echo postgresql${PG_MAJOR}-llvmjit ) \
		psmisc \
		rsync \
		$( printf '11\n'${PG_MAJOR} | sort -VC && echo timescaledb_${PG_MAJOR} ) \
		wal2json${PG_MAJOR//.} \
		file \
		unzip \
		tar \
		bzip2 \
		lz4 \
	&& ${PACKAGER} -y install \
		--setopt=tsflags='' \
		--enablerepo="epel" \
		pgaudit_analyze \
	&& ${PACKAGER} -y clean all --enablerepo="epel" ; \
fi

# ===== Steps unique to this image after here =====
LABEL name="postgres" \
	summary="PostgreSQL ${PG_FULL}" \
	description="Allows multiple deployment methods for PostgreSQL, including basic single primary, streaming replication with synchronous and asynchronous replicas. Includes utilities and tools for Auditing (pgaudit), statement tracking,  Backup/Restore (pgbackrest, pg_basebackup, pgdump, pgrestore) and Benchmarking (pgbench)." \
	io.k8s.description="Radondb PostgreSQL is the trusted open source distribution of PostgreSQL" \
	io.k8s.display-name="Radondb PostgreSQL" \
	io.openshift.tags="postgresql,postgres,sql,nosql,database,radondb" \
	postgresql.version.major="${PG_MAJOR}" \
	postgresql.version="${PG_FULL}"

# set up radondb directory
RUN mkdir -p /opt/radondb/bin /opt/radondb/conf /pgdata /pgwal /pgconf /recover /backrestrepo

RUN chown -R postgres:postgres /opt/radondb /var/lib/pgsql \
		/pgdata /pgwal /pgconf /recover /backrestrepo &&  \
	chmod -R g=u /opt/radondb /var/lib/pgsql \
		/pgdata /pgwal /pgconf /recover /backrestrepo

# open up the postgres port
EXPOSE 5432

ADD bin/postgres_common /opt/radondb/bin
ADD bin/common /opt/radondb/bin
ADD conf/postgres_common /opt/radondb/conf
ADD tools/pgmonitor/postgres_exporter/common /opt/radondb/bin/modules/pgexporter
ADD tools/pgmonitor/postgres_exporter/linux /opt/radondb/bin/modules/pgexporter

RUN mkdir /.ssh && chown 26:0 /.ssh && chmod g+rwx /.ssh && rm -f /run/nologin

# add volumes to allow override of pg_hba.conf and postgresql.conf
# add volumes to offer a restore feature
# add volumes to allow storage of postgres WAL segment files
# add volumes to locate WAL files to recover with
# add volumes for pgbackrest to write to
# The VOLUME directive must appear after all RUN directives to ensure the proper
# volume permissions are applied when building the image
VOLUME ["/sshd", "/pgconf", "/pgdata", "/pgwal", "/recover", "/backrestrepo"]

# Defines a unique directory name that will be utilized by the nss_wrapper in the UID script
ENV NSS_WRAPPER_SUBDIR="postgres"

ENTRYPOINT ["/opt/radondb/bin/uid_postgres.sh"]

USER 26

CMD ["/opt/radondb/bin/start.sh"]
