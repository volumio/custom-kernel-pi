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
cd ..

for file in patches/$KERNEL_VERSION/*
   do
	PATCH=`echo $file| rev | cut -d/ -f1 | rev`
	cp $file linux/
	echo Applying $PATCH
	cd linux
	patch -p1 < "$PATCH"
	rm $PATCH
	cd ..
done



#KERNEL=kernel
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig


#KERNEL=kernel7
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig


### ARCHIVE CREATION
mkdir ../kernel-4.9.65
mkdir ../kernel-4.9.65/boot
../kernel-4.9.65/boot/overlays
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/home/volumio/custom-kernel-pi/kernel-4.9.65 modules_install
rm /home/volumio/custom-kernel-pi/kernel-4.9.65/lib/modules/4.9.65-v7+/build
rm /home/volumio/custom-kernel-pi/kernel-4.9.65/lib/modules/4.9.65-v7+/source
cp arch/arm/boot/zImage ../kernel-4.9.65/boot/$KERNEL.img
cp arch/arm/boot/dts/*.dtb ../kernel-4.9.65/boot/
cp arch/arm/boot/dts/overlays/*.dtb* ../kernel-4.9.65/boot/overlays
cp arch/arm/boot/dts/overlays/README ../kernel-4.9.65/boot/overlays
tar zcvf /home/volumio/custom-kernel-pi/pi-kernel-4.9.65.tar.gz -C /home/volumio/custom-kernel-pi/kernel-4.9.65 .
