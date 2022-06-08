#!/bin/bash

# for provisional setup (no spack modulepaths yet)
is_avail_spack="$( module is-avail spack/0.17.0} ; echo "$?" )"
if [ "${is_avail_spack}" != "0" ] ; then
  module use /software/setonix/2022.05/pawsey_temp
  module load pawsey_temp
  module swap PrgEnv-gnu PrgEnv-cray
  module swap PrgEnv-cray PrgEnv-gnu
fi

module load spack/0.17.0

spack spec nano

# "spack" user uses "spack" group (default)
# for all other users, need sg $PAWSEY_PROJECT -c '<bla>'
spack install nano
