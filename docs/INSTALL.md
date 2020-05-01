# installation

Create arch install medium and boot from that device

## Verify boot mode

```bash
# ls /sys/firmware/efi/efivars
```

if directory does not exist -> UEFI not enabled

## Connect to the internet

Ensure network interface listed

```bash
# ip link
```

Connect via ETHERNET

### WIFI

check driver status

```bash
$ lspci -k
06:00.0 Network controller: Intel Corporation WiFi Link 5100
  Subsystem: Intel Corporation WiFi Link 5100 AGN
  Kernel driver in use: iwlwifi
  Kernel modules: iwlwifi
```

also check `ip link` to see if a wireless interface was created

Following will create a profile in /etc/netctl

```bash
wifi-menu
```

connect to

```bash
netctl switch-to <name>
```

If already interface up do

```bash
ip link set <interface> down
```

To list the connection

```bash
iw dev
```

update system clock

```bash
timedatectl set-ntp true
timedatectl statusi
```

## Volumes

```bash
fdisk -l
```

[Details](https://turlucode.com/arch-linux-install-guide-efi-lvm-luks/)

### Partition

```bash
cgdisk /dev/nme0n1
## Boot partition
# New
# First sector enter
# Size in Sector -> 1GiB -> Enter
# Hex Code or GUID -> EF00 -> Enter
# Partition name -> boot -> Enter
## LVM Partition
# New
# Size xGB -> Enter (x is free space)
# Hex Code or GUID -> Enter
# Partition name -> Enter
## Verify
## Write
```

```bash
lsblk
```

### Create volumes

Create LVM partitions root swap and home

```bash
pvcreate /dev/nvme0n1p2
vgcreate Vol /dev/nvme0n1p2
lvcreate -L 20G -n root Vol
lvcreate -L 1028M -n swap Vol
lvcreate -l 100%FREE -n home Vol
```

```bash
cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/mapper/Vol-root
cryptsetup open /dev/mapper/Vol-root root
mkfs.ext4 /dev/mapper/root
# Also format boot!!!!
mkfs.vfat -F32 /dev/nvme0n1p1
```

```bash
mount /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

## Install arch linux

```bash
vim /etc/pacman.d/mirrorlist
# edit mirrorlist, reorder to have wanted mirror at first place
pacstrap /mnt base base-devel
```

```bash
genfstab -U /mnt >> /mnt/etc/fstab
# Verify /mnt/etc/fstab root need to be mounted
# change root into new system
arch-chroot /mnt
```

```bash
# timezone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
# generate /etc/adjtime
hwclock --systohc
```

```bash
# Uncomment en_es.UTF-8 and other needed locales in /etc/locale.gen and generate
locale-gen
# create locale.conf file and set LANG
/etc/locale.conf
LANG=en_US.UTF-8
# keyboard layout create /etc/vconsole.conf
KEYMAP=us
```

```bash
# network configuration edit /etc/hostname and add hostname
# add matching entries to /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 myhostname.localdomain myhostname
```

## Initramfs

```bash
# edit /etc/mkinitcpio.conf add keyboard keymap lvm2 and encrypt
HOOKS="... keyboard keymap modconf block lvm2 encrypt ... filesystems fsck"
# regenerate
mkinitcpio -p linux
```

## bootmgr

```bash
pacman -S efibootmgr
pacman -S grub
# edit /etc/default/grub
...
GRUB_CMDLINE_LINUX="... cryptdevice=/dev/Vol/root:root:allow-discards root=/dev/mapper/root ..."
GRUB_ENABLE_CRYPTODISK=y
...
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg
```

## encrypt logical volume home

```bash
# generate keyfile
mkdir -m 700 /etc/luks-keys
dd if=/dev/random of=/etc/luks-keys/home bs=1 count-256 status=progress
# encrypt home first using a password and then add the generated keyfile
cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/mapper/Vol-home
cryptsetup luksAddKey /dev/mapper/Vol-home /etc/luks-keys/home
# open, format and mount home
cryptsetup -d /etc/luks-keys/home open /dev/Vol/home home
mkfs.ext4 /dev/mapper/home
mount /dev/mapper/home /home
```

## Configure fstab and cryttab

```bash
# edit /etc/crypttab and add
swap  /dev/Vol/swap  /dev/urandom  swap,cipher=aes-xts-plain64,size=256
home  /dev/Vol/home            /etc/luks-keys/home
```

```bash
# edit /etc/fstab and add
/dev/mapper/swap  none   swap  defaults,pri=-2 0 0
/dev/mapper/home  /home  ext4  defaults 0 2
```

### install microcode

For CPU updates

```bash
pacman -S intel-ucode
# regenerate grub config
grub-mkconfig -o /boot/grub/grub.cfg
```
