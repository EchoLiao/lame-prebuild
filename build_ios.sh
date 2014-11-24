#!/bin/sh

# http://lame.sourceforge.net/
# http://sourceforge.net/projects/lame/files/lame/

major=3
minor=99
micro=5
mmcro=1

SDK_VERS=8.1
XCD_ROOT="/Applications/Xcode.app/Contents/Developer"
TOL_ROOT="${XCD_ROOT}/Toolchains/XcodeDefault.xctoolchain"
SDK_ROOT="${XCD_ROOT}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDK_VERS}.sdk"
SDK_SML_ROOT="${XCD_ROOT}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDK_VERS}.sdk"

export PATH=$TOL_ROOT/usr/bin:$PATH

work=`pwd`
srcs=$work/src
buid=$work/build
insl=$buid/install
name=lame-${major}.${minor}.${micro}
pakt=${name}.tar.gz
dest=$work/lame-iOS-${major}.${minor}.${micro}.${mmcro}.tgz

rm -rf $srcs $buid $dest && mkdir -p $srcs $buid

[[ ! -e $pakt ]] && {
  wget http://sourceforge.net/projects/lame/files/lame/${major}.${minor}/$pakt
}

archs="armv7 armv7s arm64 i386 x86_64"

for a in $archs; do
  case $a in
    arm*)
      sys_root=${SDK_ROOT}
      host=arm-apple-darwin9
      ;;
    i386|x86_64)
      sys_root=${SDK_SML_ROOT}
      host=${a}-apple-darwin9
      ;;
  esac
  prefix=$insl/$a && rm -rf $prefix && mkdir -p $prefix
  rm -rf $srcs && mkdir -p $srcs && cd $work && tar xvzf $pakt -C $srcs && cd $srcs/$name
  chmod +x bootstrap
  ./configure \
    CFLAGS="  -arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    CXXFLAGS="-arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    LDFLAGS=" -arch $a -isysroot $sys_root -miphoneos-version-min=7.0" \
    --host=$host \
    --prefix=$prefix \
    --disable-shared \
    --enable-static \
    --disable-frontend \
    && make \
    && make install
  lipo_archs="$lipo_archs $prefix/lib/libmp3lame.a"
done

univ=$insl/universal && mkdir -p $univ/lib
cp -r $prefix/include $univ/
lipo $lipo_archs -create -output $univ/lib/libmp3lame.a
ranlib $univ/lib/libmp3lame.a
strip -S $univ/lib/libmp3lame.a

cd $univ && tar cvzf $dest *
