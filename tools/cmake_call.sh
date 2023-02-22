#!/bin/sh

: ${R_HOME=$(R RHOME)}
RSCRIPT_BIN=${R_HOME}/bin/Rscript
NCORES=`${RSCRIPT_BIN} -e "cat(min(2, parallel::detectCores(logical = FALSE)))"`
TEMPPATH=$1

#### CMAKE CONFIGURATION ####
. ./inst/scripts/cmake_config.sh
if test -z "${CMAKE_BIN}"; then
  CMAKE_BIN="$1"
  if test -z "${CMAKE_BIN}"; then
    echo "Could not find 'cmake'"
    exit 1
  fi
fi

ADDITIONAL_FLAGS=" -fPIC -O2 -Wno-c++11-long-long "
if [[ `uname` -eq Darwin ]] ; then
  CMAKE_BUILD_TYPE=Release
fi
if [[ $TRAVIS -eq true ]] ; then
  CMAKE_BUILD_TYPE=Release
fi

ADDITIONAL_FLAGS=" -fPIC -O2 -Wno-c++11-long-long "
if [[ `uname` -eq Darwin ]] ; then
  CMAKE_BUILD_TYPE=Release
fi
if [[ $TRAVIS -eq true ]] ; then
  CMAKE_BUILD_TYPE=Release
fi

cd "${TEMPPATH}/ITKR2-builder/ITK-build"

${CMAKE_BIN} \
    -DCMAKE_BUILD_TYPE:STRING="${CMAKE_BUILD_TYPE}" \
    -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} ${ADDITIONAL_FLAGS} -DNDEBUG  "\
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${ADDITIONAL_FLAGS} -DNDEBUG  "\
    -DITK_USE_GIT_PROTOCOL:BOOL=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH="${R_PACKAGE_DIR}"/  \
    -DITK_LEGACY_REMOVE:BOOL=OFF  \
    -DITK_FUTURE_LEGACY_REMOVE:BOOL=OFF \
    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
    -DModule_AdaptiveDenoising:BOOL=ON \
    -DModule_GenericLabelInterpolator:BOOL=ON \
    -DKWSYS_USE_MD5:BOOL=ON \
    -DITK_WRAPPING:BOOL=OFF \
    -DModule_MGHIO:BOOL=ON \
    -DModule_ITKDeprecated:BOOL=OFF \
    -DModule_ITKReview:BOOL=ON \
    -DModule_ITKVtkGlue:BOOL=OFF \
    -D ITKGroup_Core=ON \
    -D Module_ITKReview=ON \
    -D ITKGroup_Filtering=ON \
    -D ITKGroup_IO=ON \
    -D ITKGroup_Numerics=ON \
    -D ITKGroup_Registration=ON \
    -D ITKGroup_Segmentation=ON ../ITK

make -j${NCORES}
make install
cd ../../
