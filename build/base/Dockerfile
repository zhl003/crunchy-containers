ARG BASE_IMAGE_OS
ARG DOCKERBASEREGISTRY
FROM ${DOCKERBASEREGISTRY}${BASE_IMAGE_OS}

# For RHEL8 all arguments used in main code has to be specified after FROM
ARG BASEOS
ARG RELVER
ARG DFSET
ARG PACKAGER
ARG PG_LBL

MAINTAINER  RadonDB

LABEL vendor="RadonDB" \
	url="https://radondb.com" \
	release="${RELVER}" \
	org.opencontainers.image.vendor="RadonDB" \
	os.version="7.7"
COPY licenses /licenses

ENV TZ=Asia/Shanghai
COPY conf/pip.conf pip.conf
ENV PIP_CONFIG_FILE pip.conf
RUN sed -e "s|^mirrorlist=|#mirrorlist=|g" \
         -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/8.5.2111|g" \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo


ENV LC_ALL en_US.utf-8
ENV LANG en_US.utf-8

ARG EPEL8_RPM=https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm


RUN if [ "$BASEOS" = "centos8" ] ; then \
	${PACKAGER} -y update --nodocs \
	&& ${PACKAGER} -y install \
		--setopt=skip_missing_names_on_install=False \
		--nodocs \
		epel-release \
		glibc-langpack-en \
		bind-utils \
		gettext \
		hostname \
		procps-ng \
		nss_wrapper \
	&& ${PACKAGER} -y clean all ; \
fi
# Add any available RadonDB PG repo files
ADD conf/radondbpg${PG_LBL}.repo /etc/yum.repos.d/
# Import both keys to support all required repos
RUN if [ "$BASEOS" = "centos8" ] ; then \
	${PACKAGER} -qy module disable postgresql ; \
fi
