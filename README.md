# os-arch

![Lint](https://github.com/AndreasAugustin/os-arch/workflows/Lint/badge.svg)

This repository contains build information about the OS.

## DEV

The development environment targets are located in the [Makefile](Makefile)

```bash
make help
```

## MAKEPKG

The main purpose of this repository is to be able to recreate my system.
The most `pacman` installations are done with `makepkg`.

- [Guide][makepkg-guide]
- [Guidelines][makepkg-guidelines]

### Commands

Get the checksum

```bash
makepkg -g
```

```MAKEPKG
# Maintainer: Andreas Augustin <dev@andreas-augustin.org>
pkgname=NAME
pkgver=VERSION
pkgrel=1
pkgdesc=""
arch=()
url=""
license=('GPL')
groups=()
depends=()
makedepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=($pkgname-$pkgver.tar.gz)
noextract=()
md5sums=() #autofill using updpkgsums

build() {
  cd "$pkgname-$pkgver"

  ./configure --prefix=/usr
  make
}

package() {
  cd "$pkgname-$pkgver"

  make DESTDIR="$pkgdir/" install
}
```

[makepkg-guide]: https://wiki.archlinux.org/index.php/Creating_packages
[makepkg-guidelines]: https://wiki.archlinux.org/index.php/Arch_package_guidelines
