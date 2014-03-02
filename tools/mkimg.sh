#!/bin/sh

# img=test.img
while test -n "$1"; do
  case $1 in
    -o)
      shift
      img="$1";
      ;;

    -*)
      echo "Error: unknown option $1"
      exit 1
      ;;

    *)
      if test "x$rbf" = "x"; then
        rbf="$1"
      else
        echo "Error: unknown argument $1"
      fi
      ;;
  esac
  shift
done

if test "x$img" = "x"; then
  echo "Warning: No image specified"
  img=test.img
fi

if test "x$rbf" = "x"; then
  echo "Warning: no RBF file specified"
  rbf=/usr1/fun/fpga/simple_counter/fpga/output_files/simple_counter.rbf
fi


# rbf=soc_system.rbf

blocks=`expr 50 '*' 1024`

dd if=/dev/zero of=$img count=$blocks
fat_last_sector=`expr $blocks - 1`

echo "$img size=`du $img`"

fdisk $img <<END
n
p
1
4096
${fat_last_sector}
t
4
n
p
2
2048

t
2
a2
w
END

fat32=`fdisk -l $img | grep FAT`
fat32_start=`echo $fat32 | sed -e 's/^.* \([0-9][0-9][0-9]*\) \([0-9][0-9][0-9]*\) \([0-9][0-9][0-9]*\).*$/\1/g'`
fat32_end=`echo $fat32 | sed -e 's/^.* \([0-9][0-9][0-9]*\) \([0-9][0-9][0-9]*\) \([0-9][0-9][0-9]*\).*$/\2/g'`

fat32_start_b=`expr $fat32_start '*' 512`
fat32_end_b=`expr $fat32_end '*' 512`
fat32_len=`expr $fat32_end - $fat32_start`
fat32_len_b=`expr $fat32_end_b - $fat32_start_b`

# Image the uboot partition

# Copy the preloader in
for i in 0 1 2 3; do
  seek=`expr 2048 + $i '*' 128`
  echo "preloader @ $seek"
  dd conv=notrunc if=preloader.img of=$img seek=$seek
  echo "$img size=`du $img`"
done

# Now, copy the uboot image in
seek=`expr 262144 / 512` # 0x40000
seek=`expr $seek + 2048`
dd conv=notrunc if=u-boot-sockit.img of=$img seek=$seek
echo "$img size=`du $img`"

# Now, create a FAT32 filesystem
truncate -s ${fat32_len_b} ${img}.vfat
mkfs.vfat ${img}.vfat

mntdir=`mktemp -d`
# sudo mount -t vfat ${img}.vfat $mntdir
fusefat -o rw+ ${img}.vfat $mntdir
# sudo cp zImage socfpga.dtb u-boot.scr $mntdir
cp u-boot.scr $mntdir
cp $rbf $mntdir/soc_system.rbf

for i in 1 2 3 4; do
  sleep 1
  fusermount -u $mntdir
  if test $? -ne 0; then
    echo "Re-trying unmount..."
  else
    break
  fi
done

rm -rf $mntdir

printf "fat32_start_b=0x%08x\n" ${fat32_start_b}
dd conv=notrunc if=${img}.vfat of=${img} seek=${fat32_start}
#rm ${img}.vfat

#loop=`sudo losetup -f`
#sudo losetup --offset $fat32_start --sizelimit $fat32_len $loop test.img
#sudo mkfs.vfat -F 16 -n "data" $loop
#sudo losetup -d $loop
#echo "sudo losetup --offset $fat32_start_b --sizelimit $fat32_len_b $loop test.img"
#sudo losetup --offset $fat32_start_b --sizelimit $fat32_len_b $loop test.img


#sudo mount -t vfat ${loop} $mntdir
#echo "post-mount"
#sudo losetup -d $loop



