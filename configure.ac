AC_PREREQ([2.69])
AC_INIT([ITKR],[1.0.0])

## Set R_HOME, respecting an environment variable if set
: ${R_HOME=$(R RHOME)}
if test -z "${R_HOME}"; then
   AC_MSG_ERROR([Could not determine R_HOME.])
fi

RSCRIPT_BIN=${R_HOME}/bin/Rscript
NCORES=`${RSCRIPT_BIN} -e "cat(min(2, parallel::detectCores(logical = FALSE)))"`
current_workdir=${pwd}

CXX_STD=CXX17
CXX=`"${R_HOME}/bin/R" CMD config CXX`
if test -z "${CXX}"; then
    AC_MSG_ERROR([No C++ compiler available])
fi
CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXXFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
CXX17FLAGS=`"${R_HOME}/bin/R" CMD config CXX17FLAGS`
CXX11FLAGS=`"${R_HOME}/bin/R" CMD config CXX11FLAGS`
AC_LANG(C++)
AC_REQUIRE_CPP
AC_PROG_CXX

AC_PATH_PROG(CMAKE_BIN, cmake, no)
if test x"${CMAKE_BIN}" == x"no"; then
  . inst/scripts/cmake_config.sh
  if test -z "${CMAKE_BIN}"; then
    ## also error to end configure here
    AC_MSG_ERROR([Could not find 'cmake'.])
  fi
fi

# unpack ITK
AC_MSG_RESULT([unpacking ITK... to ${TMPDIR}/ITKR2-builder])
"${R_HOME}/bin/Rscript" --no-save --no-restore 'tools/unpack_itk.R' ${TMPDIR}

AC_MSG_RESULT([compiling ITK])
./tools/cmake_call.sh "${TMPDIR}"

AC_MSG_RESULT([removing temporary directory ITKR2-builder])
rm -rf ${TMPDIR}/ITKR2-builder


# rm inst/ITK/ITK-sourcefile.tar.gz
# rm -rf CMakeFiles/ && rm -rf Modules/ && rm -rf CMakeTmp/ \
# rm -f Makefile && rm -rf Utilities/Doxygen



# AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
