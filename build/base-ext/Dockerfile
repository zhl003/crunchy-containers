ARG BASEOS
ARG BASEVER
ARG PG_FULL
ARG PREFIX
FROM ${PREFIX}/radondb-base:${BASEOS}-${PG_FULL}-${BASEVER}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG BASEOS
ARG PACKAGER

LABEL name="radondb-base-ext" \
	summary="Includes base extensions required to load in additional PostgreSQL extensions." \
	description="Includes base extensions required to load in additional PostgreSQL extensions."

RUN if [ "$BASEOS" = "centos8" ] ; then \
	${PACKAGER} -y install --nodocs \
		--setopt=skip_missing_names_on_install=False \
		--enablerepo="powertools" \
		perl \
	&& ${PACKAGER} -y clean all ; \
fi
