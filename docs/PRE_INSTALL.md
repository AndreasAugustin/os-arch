# user configuration

[Basic guide](https://turlucode.com/arch-linux-install-guide-step-1-basic-installation/)

```bash
packman -S sudo bash-completion
useradd -m -g users -G wheel,storage,power -s /bin/bash $(whoami)
passwd $(whoami)
EDITOR=vim visudo
# uncomment line for group %wheel
usermod -aG video $(whoami) # append group video to current user
```

## desktop

```bash
pacman -S sway
# choose noto-fonts, mesa open-gl driver
pacman -S swayidle swaylock ttf-hack ttf-font-awesome
```

### display manager

```bash
# not configured yet
pacman -S gdm gdm3setup
```

### zsh

```bash
pacman -S git git-crypt
mkdir ~/tools
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh >> ~/tools/oh_my_zsh_install.sh
```

### docker

```bash
pacman -S docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $(whoami)
# change the default docker
sudo systemctl status docker
# get location ov docker.service
sudo vim <docker.service_location>
# Edit ExecStart line to look like this ExecStart =/usr/bin/dockerd -g /new/docker/root/dir -H fd://
sudo systemctl daemon-reload
sudo systemctl restart docker
docker info
# validate new root dir
```

```bash
sudo pacman -S vagrant
```

### sound

```bash
pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils
alsamixer
# disable mute
```

### screenshots

```bash
pacman -S grim slurp
```

### Tools

```bash
# paccache
sudo pacman -S pacman-contrib
```

```bash
# bluetooth
sudo pacman -S bluez bluez-utils
```

```bash
pacman -S openssh
```

```bash
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -is
```

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
# git clone https://aur.archlinux.org/nerd-fonts-complete.git
# cd nerd-fonts-complete
# makepkg -is
```

```bash
git clone https://aur.archlinux.org/wofi-hg.git
pacman -S mercurial
cd wofi-hg
makepkg -i -r
```

```bash
# fonts
pacman -S otf-font-awesome
# install nmtui and other tools
sudo pacman -S networkmanager
# playerctl
sudo pacman -S playerctl
# Power management
sudo pacman -S powertop tlp
sudo systemctl enable tlp
sudo systemctl start tlp
````

```bash
# file manager
# sudo pacman -S vifm
sudo pacman -S ranger
```

```bash
# notifications
sudo pacman -S mako
```

```bash
# adjust background color
sudo pacman -S intltool geoclue
git clone https://aur.archlinux.org/redshift-wayland-git.git
cd redshift-wayland-git
makepkg -ir
```

```bash
# automount usb
sudo pacman -S udisks2 ntfs-3g
```

### Development

```bash
sudo pacman -S vagrant
# TODO here is to just use minikube
sudo pacman -S minikube virtualbox kubectl
```

### Remark

```bash
# start gparted
xhost +local:
sudo gprated
```
