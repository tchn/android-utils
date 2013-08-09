#!/bin/zsh
# Usage: source prog_name <your ndk root dir> <your project name>

ndk_root=$1
proj=$2
typeset -a ndk_vers
typeset -a ndk_platforms
ndk_vers=($(ls "${ndk_root}"))
ndk_ver=""
ndk_path=""
ndk_platform=""
platform_ext_root="/opt/lib/android-ext"
platform_ext=""

echo "Select NDK to use:"
select i in $ndk_vers; do
    ndk_ver="${i}"; echo "${ndk_ver}";
    break;
done

ndk_path="${ndk_root}/${ndk_ver}"
ndk_platforms=($(ls "${ndk_path}/platforms"))

echo "Select target android version:"
select i in $ndk_platforms; do
    ndk_platform="${i}"; echo "${ndk_platform}";
    break;
done

platform_ext="${platform_ext_root}/${proj}/${ndk_platform}"

if [ -d "${platform_ext}" ]; then
    echo "Project toolchain already exists... Using the existing."
else
    mkdir -p "${platform_ext}"
    bash $ndk_path/build/tools/make-standalone-toolchain.sh --platform="${ndk_platform}" --install-dir="${platform_ext}"

fi

export SYSROOT="${ndk_path}/platforms/${ndk_platform}/arch-arm"
unset CFLAGS
CFLAGS="--sysroot=${SYSROOT} -fPIC -fomit-frame-pointer -ftree-vectorize -O3 -march=armv7-a -mandroid -mfpu=neon -mvectorize-with-neon-quad"
unset CPPFLAGS

export PATH=$PATH:$platform_ext/bin
echo "\nPATH:"
echo $PATH
