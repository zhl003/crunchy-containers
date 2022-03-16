#!/bin/bash

set -e -u

REGISTRY=docker.io/radondb
VERSION=${CCP_IMAGE_TAG?}
GIS_VERSION=${CCP_POSTGIS_IMAGE_TAG?}
IMAGES=(
    radondb-pgbackrest
    radondb-pgbackrest-repo
    radondb-pgadmin4
    radondb-pgbadger
    radondb-pgbouncer
    radondb-pgpool
    radondb-postgres
    radondb-upgrade
    radondb-postgres-ha
)

GIS_IMAGES=(
    radondb-postgres-gis
    radondb-postgres-gis-ha
)

function echo_green() {
    echo -e "\033[0;32m"
    echo "$1"
    echo -e "\033[0m"
}

for image in "${IMAGES[@]}"
do
    echo_green "=> Pushing ${REGISTRY?}/$CCP_IMAGE_PREFIX/${image?}:${VERSION?}.."
#    docker tag $CCP_IMAGE_PREFIX/${image?}:${VERSION?} ${REGISTRY?}/$CCP_IMAGE_PREFIX/${image?}:${VERSION?}
#    docker push ${REGISTRY?}/$CCP_IMAGE_PREFIX/${image?}:${VERSION?}
docker tag $CCP_IMAGE_PREFIX/${image?}:${VERSION?} ${REGISTRY?}/${image?}:${VERSION?}
docker push ${REGISTRY?}/${image?}:${VERSION?}
done

for gis_image in "${GIS_IMAGES[@]}"
do
    echo_green "=> Pushing ${REGISTRY?}/$CCP_IMAGE_PREFIX/${gis_image?}:${GIS_VERSION?}.."
#    docker tag $CCP_IMAGE_PREFIX/${gis_image?}:${GIS_VERSION?} ${REGISTRY?}/$CCP_IMAGE_PREFIX/${gis_image?}:${GIS_VERSION?}
#    docker push ${REGISTRY?}/$CCP_IMAGE_PREFIX/${gis_image?}:${GIS_VERSION?}
docker tag $CCP_IMAGE_PREFIX/${gis_image?}:${GIS_VERSION?} ${REGISTRY?}/${gis_image?}:${GIS_VERSION?}
docker push ${REGISTRY?}/${gis_image?}:${GIS_VERSION?}
done

echo_green "=> Done!"

exit 0
