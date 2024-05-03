if [[ -z $(command -v guix) ]]
then
    echo "You must boot to guix system to continue installation. Aborting..."
    exit
fi

source ./config.env
if [[ -z "${GUIX_OS_USER_USERNAME}" ]]
then
    echo "You did not configure 'config.env' file. Aborting installation."
    exit
fi

echo "Did you populate 'config.env' file appropriately?"
echo "Do you really want to install GUIX OS to ${GUIX_OS_INSTALL_DISK}?"
echo "WARNING: All data in ${GUIX_OS_INSTALL_DISK} will be gone!!!!!!!"

while true
do    
    read -p "Please answer Y or N" yn
    echo ""
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
    esac
done

if ping -q -c 1 -W 1 8.8.8.8 > /dev/null
then
    echo "Internet checked"
else
    echo "No internet connection. Aborting..."
    exit
fi

export GUIX_OS_NIC_NAME=""
for NIC in $(find /sys/class/net -mindepth 1 -maxdepth 1 -lname '*virtual*' -prune -o -printf '%f\n')
do
    NAME=$(ip addr show | grep $NIC | grep LOWER_UP | awk '{print $2}' | cut -d ':' -f 1)
    if [[ ! -z "$NAME" ]]
    then
        GUIX_OS_NIC_NAME=$NAME
        break
    fi
done

echo "Checking target drive..."
DISKCHECK=$(sudo lsblk -f | grep $GUIX_OS_INSTALL_DISK | awk '{print $2}' | grep ext4)
if [ ! -z "$DISKCHECK" ]
then
	echo "Warning! It seems like $GUIX_OS_INSTALL_DISK contains Linux installation!"
	echo "Aborting. Manually wipe $GUIX_OS_INSTALL_DISK with fdisk to carry out Guix installation!"
	echo "(Remove all file systems on $GUIX_OS_INSTALL_DISK)"
	exit
fi

(
echo g
echo n
echo
echo
echo +2G
echo n
echo
echo
echo +${GUIX_OS_SWAP_SIZE_IN_GB}G
echo n
echo
echo
echo
echo t
echo 1
echo 1
echo t
echo 2
echo 19
echo t
echo 3
echo 20
echo w
) | fdisk $GUIX_OS_INSTALL_DISK && sync

PART_STATUS=$?
if [ $PART_STATUS -ne 0 ]
then
    echo "Failed to partition ${GUIX_OS_INSTALL_DISK}. Aborting installation..."
    exit
fi

sync

export PART_NAME_ESP=$(fdisk -l $GUIX_OS_INSTALL_DISK | grep EFI | awk '{print $1}')
mkfs.fat -F 32 $PART_NAME_ESP

export PART_NAME_SWAP=$(fdisk -l $GUIX_OS_INSTALL_DISK | grep swap | awk '{print $1}')
mkswap $PART_NAME_SWAP

export PART_NAME_ROOT=$(fdisk -l $GUIX_OS_INSTALL_DISK | grep filesystem | awk '{print $1}')
mkfs.ext4 $PART_NAME_ROOT

sync

export GUIX_OS_UUID_ESP=$(blkid | grep $PART_NAME_ESP | awk '{print $2}' | cut -d '=' -f 2)
export GUIX_OS_UUID_SWAP=$(blkid | grep $PART_NAME_SWAP | awk '{print $2}' | cut -d '=' -f 2)
export GUIX_OS_UUID_ROOT=$(blkid | grep $PART_NAME_ROOT | awk '{print $2}' | cut -d '=' -f 2)

mount $PART_NAME_ROOT /mnt
swapon $PART_NAME_SWAP
mkdir -p /mnt/efi
mount $PART_NAME_ESP /mnt/efi

cat ./files/template.scm \
    | sed "s|{{ GUIX_OS_HOSTNAME }}|${GUIX_OS_HOSTNAME}|g" \
    | sed "s|{{ GUIX_OS_KEYBOARD }}|${GUIX_OS_KEYBOARD}|g" \
    | sed "s|{{ GUIX_OS_LOCALE }}|${GUIX_OS_LOCALE}|g" \
    | sed "s|{{ GUIX_OS_TIMEZONE }}|${GUIX_OS_TIMEZONE}|g" \
    | sed "s|{{ GUIX_OS_UUID_ESP }}|${GUIX_OS_UUID_ESP}|g" \
    | sed "s|{{ GUIX_OS_UUID_SWAP }}|${GUIX_OS_UUID_SWAP}|g" \
    | sed "s|{{ GUIX_OS_UUID_ROOT }}|${GUIX_OS_UUID_ROOT}|g" \
    | sed "s|{{ GUIX_OS_NIC_NAME }}|${GUIX_OS_NIC_NAME}|g" \
    | sed "s|{{ GUIX_OS_USER_USERNAME }}|${GUIX_OS_USER_USERNAME}|g" \
    | sed "s|{{ GUIX_OS_USER_COMMENT }}|${GUIX_OS_USER_COMMENT}|g" \
> ./system-config.scm


herd start cow-store /mnt
guix archive --authorize < ./files/signing-key.pub

echo "Starting installation..."

# Keep trying
while true; do
	guix pull -C ./files/channels.scm && \
	guix time-machine -C ./files/channels.scm -- system init ./system-config.scm --substitute-urls='https://ci.guix.gnu.org https://bordeaux.guix.gnu.org https://substitutes.nonguix.org https://guix.bordeaux.inria.fr' /mnt && \
	break

	sleep 60
done

mkdir -p /mnt/etc/guix
cp ./files/channels.scm /mnt/etc/guix/
cp ./system-config.scm /mnt/etc/config.scm
cp -r ../../Guix /mnt/root/

# clean up
sync
umount -A --recursive /mnt
swapoff -a

echo "Installation finished. You can reboot to the new system."

