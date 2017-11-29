#!/bin/sh

KERNEL_VERSION=$1


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


if [ ! -d tools ]; then
  git clone https://github.com/raspberrypi/tools
fi


if [ ! -d linux ]; then
  git clone https://github.com/raspberrypi/linux
fi

echo PATH=\$PATH:~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin >> ~/.bashrc
source ~/.bashrc


echo "Firmware revision is"  $FIRMWARE_COMMIT
KERNEL_REV=`curl -L https://github.com/Hexxeh/rpi-firmware/raw/${FIRMWARE_COMMIT}/git_hash`
echo "Kernel revision is "$KERNEL_REV

cd linux
git checkout $KERNEL_REV

#for file in patches/*
#do
#  patch -p1 < "$file"
#done

#cd linux


#KERNEL=kernel
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig


#KERNEL=kernel7
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig


