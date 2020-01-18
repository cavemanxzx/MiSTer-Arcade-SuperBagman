#!/bin/bash
echo This Script rearranges the non linear addressed Roms from SuperBagman c000-ffff 
echo for use with MRA on MiSTer.
echo
echo This Script runs MiSTer or any linux box. You need "sbagman.zip" from MAME in same Dirctroy.

exit_with_error() {
  echo -e "\nERROR:\n${1}\n"
  exit 1
}

check_dependencies() {
  if [[ $OSTYPE == darwin* ]]; then
    for j in unzip md5 cat cut dd; do
      command -v ${j} > /dev/null 2>&1 || exit_with_error "This script requires\n${j}"
    done
  else
    for j in unzip md5sum cat cut dd; do
      command -v ${j} > /dev/null 2>&1 || exit_with_error "This script requires\n${j}"
    done
  fi
}

check_permissions () {
  if [ ! -w ${BASEDIR} ]; then
    exit_with_error "Cannot write to\n${BASEDIR}"
  fi
}


uncompress_zip() {
  if [ -f ${BASEDIR}/sbagman.zip ]; then
    tmpdir=roms
    unzip -qq -d ${BASEDIR}/${tmpdir}/ ${BASEDIR}/sbagman.zip
    if [ $? != 0 ] ; then
      rm -rf ${BASEDIR}/$tmpdir
      exit_with_error "Something went wrong\nwhen extracting\n${zip}"
    fi
  else
    exit_with_error "Cannot find ${zip}"
  fi
}






BASEDIR=$(dirname "$0")

echo "Generating ROM ..."

## verify dependencies
check_dependencies


## extract package
uncompress_zip

cd ./roms

##split the roms
dd skip=0 count=3584 if=./13.8d of=c000_13.8d bs=1
dd skip=3584 count=512 if=./13.8d of=fe00_13.8d bs=1

dd skip=0 count=3584 if=./16.8k of=f000_16.8k bs=1
dd skip=3584 count=512 if=./16.8k of=ce00_16.8k bs=1

dd skip=0 count=1024 if=./14.8f of=d000_14.8f bs=1
dd skip=1024 count=512 if=./14.8f of=e400_14.8f bs=1
dd skip=1536 count=2560 if=./14.8f of=d600_14.8f bs=1

dd skip=0 count=1024 if=./15.8j of=e000_15.8j bs=1
dd skip=1024 count=512 if=./15.8j of=d400_15.8j bs=1
dd skip=1536 count=2560 if=./15.8j of=e600_15.8j bs=1

cat c000_13.8d ce00_16.8k d000_14.8f d400_15.8j d600_14.8f e000_15.8j e400_14.8f e600_15.8j f000_16.8k fe00_13.8d > ./c000_ffff_mister.bin

rm c000_13.8d ce00_16.8k d000_14.8f d400_15.8j d600_14.8f e000_15.8j e400_14.8f e600_15.8j f000_16.8k fe00_13.8d

rm ../sbagman.zip

zip -r ../sbagman.zip *

cd ..

rm -r ./roms

echo New sbagman.zip is now generated. Copy it to your mame folder on MiSTer. Have fun...













