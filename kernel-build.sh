#!/bin/sh

KERNEL_VERSION=$1
WORKDIR=$PWD
ARCH=`uname -m`

case $KERNEL_VERSION in
    "4.4.9")
      KERNEL_REV="884"
      KERNEL_COMMIT="15ffab5493d74b12194e6bfc5bbb1c0f71140155"
      FIRMWARE_COMMIT="9108b7f712f78cbefe45891bfa852d9347989529"
      ;; 
    "4.9.51")
      KERNEL_REV="1036"
      KERNEL_COMMIT="913eddd6d23f14ce34ae473a4c080c5c840ed583"
      FIRMWARE_COMMIT=$KERNEL_COMMIT
      ;;
    "4.9.65")
      KERNEL_REV="1056"
      KERNEL_COMMIT="e4b56bb7efe47319e9478cfc577647e51c48e909"
      FIRMWARE_COMMIT=$KERNEL_COMMIT
      ;;  
esac

#if [ `getconf LONG_BIT` = "64" ]; then
  #PATH=\$PATH:$WORKDIR/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin
#else
  #PATH=\$PATH:$WORKDIR/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
#fi


echo "Firmware revision is"  $FIRMWARE_COMMIT
KERNEL_REV=`curl -L https://github.com/Hexxeh/rpi-firmware/raw/${FIRMWARE_COMMIT}/git_hash`
echo "Kernel revision is "$KERNEL_REV

echo "Preparing environment"
$WORKDIR/prepare $KERNEL_REV

echo "Applying Patches"
$WORKDIR/apply-patches $KERNEL_VERSION

echo "Compiling Kernel"
$WORKDIR/compile 

echo "Create Kernel Archive"
$WORKDIR/create-archive $KERNEL_VERSION
