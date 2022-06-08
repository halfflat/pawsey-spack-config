#!/bin/bash

# source setup variables
# if copy/pasting these commands, need to run from this directory
script_dir="$(readlink -f "$(dirname $0 2>/dev/null)" || pwd)"

# list of environments from command line
if [ "$#" -gt 1 ] ; then
  env_list="${@:2}"
else
  env_list=""
fi

envdir="${script_dir}/../environments"

nprocs="128"
if [ ! -z $1 ]; then
  nprocs="$1"
fi

timestamp="$(date +"%Y-%m-%d_%Hh%M")"
top_logdir="${SPACK_LOGS_BASEDIR:-"${script_dir}/logs"}"
logdir="${top_logdir}/install.${timestamp}"
mkdir -p ${logdir}

for env in ${env_list} ; do
  cd ${envdir}/${env}
  spack env activate . 
  spack concretize -f 1> ${logdir}/spack.concretize.${env}.log 2> ${logdir}/spack.concretize.${env}.err
  if [ "${env}" == "env_roms" ] || [ "${env}" == "env_wrf" ] ; then
    sg spack -c "spack install --no-checksum -j${nprocs} --only dependencies 1> ${logdir}/spack.install.${env}.log 2> ${logdir}/spack.install.${env}.err"
  else
    sg spack -c "spack install --no-checksum -j${nprocs} 1> ${logdir}/spack.install.${env}.log 2> ${logdir}/spack.install.${env}.err"
  fi
  spack env deactivate
  cd ${script_dir}
done
