#!/usr/bin/env bash
#generate spec file

download_only_flag="${DOWNLOAD_ONLY-0}"

_topdir=/home/zhl/rpmbuild
repo_name="radondbdevpg"${1}
repo=$2
repo_full_name="${repo_name}-${repo}"
build_args='-bb'
if [ "${repo}" == "debuginfo" ]; then
    dir="debug"
elif [ "${repo}" == "source" ]; then
    dir="SRPMS"
    extra_args="--source"
    repo_full_name=${repo_name}
    build_args="-bs"
elif [ "${repo}" == "x86_64" ]; then
    dir="x86_64"
    repo_full_name=${repo_name}
else
    echo "[ERROR] repo kind"
    exit
fi
source_rpm_dir=/home/zhl/postgresql"${1}"/centos/EL8/${dir}/
repo_dir=/opt/repo/postgresql"${1}"/centos/EL8/${dir}/
spec_dir=${_topdir}/SPECS
build_root_dir=${_topdir}/BUILDROOT

download_source() {

    # curl https://api.developers.radondb.com/downloads/repo/rpm-centos/postgresql13/radondbpg13.repo >/etc/yum.repos.d/radondbpg13.repo
    # curl https://api.developers.radondb.com/downloads/repo/rpm-centos/postgresql12/radondbpg12.repo >/etc/yum.repos.d/radondbpg12.repo

    # sed -i 's/$releasever/8/g' radondbpg1*.repo
    #13 debug
    yum repo-pkgs "${repo_full_name}" list |grep -E '.x86_64|.noarch'| awk '{print $1}' | while read -r line; do
        if yumdownloader "${extra_args}" $line --disablerepo=* --enablerepo="${repo_name}"* --destdir="${source_rpm_dir}" &>/dev/null; then
            echo "OK[$line]"
        else
            echo "FAILD[$line]"
          exit
        fi
    done
}

gen_spec_file() {
    pkg_file=$1
    pkg_name=${pkg_file##*/}
    specname=${pkg_name/.rpm/.spec}
    rpmrebuild -np -s ${spec_dir}/"${specname}" "${pkg_file}"
}

unarchive_rpm() {
    pkg_file=$1
    pkg_name=${pkg_file##*/}
    cd ${build_root_dir} || exit
    [[ ${pkg_name} =~ .noarch ]] && pkg_name=${pkg_name/.noarch/.x86_64}
    mkdir "${pkg_name/.rpm/}"
    cd "${pkg_name/.rpm/}" || exit
    rpm2cpio "${pkg_file}" | cpio -idmv
}
replase_release_name(){
    pkg_file=$1
    pkg_name=${pkg_file##*/}
   

    old_release_name=$(awk '/^Release:/{print $2}' "${spec_file}")
    new_release_name="radondb.el8.centos"
    #replace release name
    sed -i "s/${old_release_name}/${new_release_name}/g" "${spec_file}"
    new_spec_file=$(echo ${spec_file}|sed "s/${old_release_name}/${new_release_name}/g")
    mv "${spec_file}" "${new_spec_file}" || exit
}
replace_name() {
    pkg_file=$1
    pkg_name=${pkg_file##*/}
    spec_file=${spec_dir}/${pkg_name/.rpm/.spec}
    
    new_release_name="radondb.el8.centos"
    new_spec_file=$(echo ${spec_file}|sed "s/${old_release_name}/${new_release_name}/g")
    [[ ${pkg_name} =~ .noarch ]] && pkg_name=${pkg_name/.noarch/.x86_64}
    #replace file
    # find ${build_root_dir}/"${pkg_name/.rpm/}" -type f | while read -r line; do
    #     sed -i "s/[Cc]runchy/radondb/g" "${line}"
    #     dir=$(dirname "${line}")
    #     file_name=$(basename "${line}")
    #     if [[ ${file_name} =~ [Cc]runchy ]]; then
    #         mv "${dir}"/"${file_name}" "${dir}"/"${file_name//[Cc]runchy/radondb}" || exit
    #     fi
    # done

    #replace forder
    mapfile -t old_forder < <(find ${build_root_dir}/"${pkg_name/.rpm/}" -type d -name "*${old_release_name}*" | tac)
    new_forder=(${old_forder[@]//${old_release_name}/${new_release_name}})
    for forder in $(seq 0 "$((${#old_forder[@]} - 1))"); do
        if [ ! -d "${new_forder[${forder}]}" ]; then
            mkdir -p "${new_forder[${forder}]}"
        fi
        # mv "${old_forder[${forder}]}" "${new_forder[${forder}]}" || exit
        rsync -axvvES "${old_forder[${forder}]}/" "${new_forder[${forder}]}/" --remove-source-files &&
            rm -rf "${old_forder[${forder}]}" || exit
    done
    # mv "${spec_file}" "${new_spec_file}" || exit
    # sed -i "s/[Cc]runchy/radondb/g" "${new_spec_file}"
}

build_and_push() {
    pkg_file=$1
    
    spec_file=${spec_dir}/${pkg_name/.rpm/.spec}
    new_release_name="radondb.el8.centos"    
    new_pkgname=${pkg_name//${old_release_name}/${new_release_name}}
    [[ ${pkg_name} =~ .noarch ]] && pkg_name=${pkg_name/.noarch/.x86_64}
    spec_file=${spec_dir}/${new_pkgname/.rpm/.spec}
    rpmbuild "${build_args}" "${spec_file}" || exit
    if [[ ${pkg_file} =~ .noarch ]]; then
        sudo cp -rp ${_topdir}/RPMS/noarch/"${new_pkgname}" ${repo_dir}
    elif [[ ${pkg_file} =~ .src. ]]; then
        sudo cp -rp ${_topdir}/SRPMS/"${new_pkgname}" ${repo_dir}
    else
        sudo cp -rp ${_topdir}/RPMS/x86_64/"${new_pkgname}" ${repo_dir}
    fi
}
#main
if [ "${download_only_flag}" == 1 ]; then

    download_source && exit
fi

for pkg in "${source_rpm_dir}"/*.rpm; do
    # pkg=${pkg_file##*/}
    pkg_name=${pkg##*/}
    spec_file=${spec_dir}/${pkg_name/.rpm/.spec}
    old_release_name=$(awk '/^Release:/{print $2}' "${spec_file}")
    gen_spec_file "${pkg}" || exit $?
    unarchive_rpm "${pkg}" || exit $?
    replase_release_name "${pkg}" || exit $?
    replace_name "${pkg}" || exit $?
    build_and_push "${pkg}" || exit $?
done

#test docker image
# docker run -d radondb/radondb-postgres-ha:centos8-13.3-4.7.0 --entrypoint /bin/sh -c "while true; do sleep 3600; done"