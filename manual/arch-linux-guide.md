# Arch Linux 클린 인스톨하는 과정

## 설치 미디어 준비하기
적당한 USB에 archiso를 굽는다.

## 펌웨어 설정 건드리기
- 완전 UEFI 모드로 설정한다
- 그 외에 신경 쓰이는 설정이 있으면 조정하기

## 설치 미디어로 부팅

### efivarfs의 존재 확인하기
`/sys/firmware/efi/efivars` 디렉토리가 존재하는지 확인한다.

### 인터넷에 연결하기
- 터미널에서는 일단 wifi-menu를 쓴다
- 연결 후에 핑 쳐보기

### 시각 동기화
```
timedatectl set-ntp true
```

### 파티션 잡기
- ESP 0.5G
- 그리고 나머지 전부

### 파일 시스템 포맷하기
- ESP는 FAT32
- 나머지 전부는 LVM을 세팅한다([참고 자료][lvm])
  - swap 파티션
  - temp 파티션
  - 루트 파티션
- 루트 파티션은 암호화한 뒤 btrfs로 포맷([참고 자료][dm-crypt])
  - `-s 512`

[lvm]: https://wiki.archlinux.org/index.php/LVM#Installing_Arch_Linux_on_LVM
[dm-crypt]: https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LUKS_on_LVM

### 마운트
```
mount -o compress=lzo <root partition> /mnt
mkdir /mnt/boot
mount <esp> /mnt/boot
```

### 미러 설정하기
`/etc/pacman.d/mirrorlist`를 잘 건드려 준다.

### `pacstrap`
- `base`
- `base-devel`
- `linux-lts`
- `git`
- `vim`
- `zsh`
- `sudo`
- `openssh`
- `noto-fonts-cjk`
- `noto-fonts-emoji`
- `gnome`
  - 이 안에 `networkmanager`가 있음
- `gnome-extra`
  - 이 안에 `gnome-tweak-tool`과 `dconf-editor`가 있음
- `ibus-hangul`
- `firefox`
- `firefox-i18n-ko`
- `chromium`

### 루트 파티션 설정
먼저 fstab과 crypttab(swap과 tmp)를 설정하고, chroot해서 이것들을 해 준다.

- `/etc/hostname` 설정
- `locale-gen`
  - `/etc/locale.conf` 설정
- `/etc/localtime` symlink
- 미러 설정 복사
- `EDITOR=vim visudo`
- wheel 유저 만들기
  - `useradd`, `passwd`, `gpasswd`
- 필요한 서비스 활성화하기
  - `gdm`이라든가
- `/etc/crypttab` 설정

### `bootctl`
[이것을 보고][systemd-boot] 적절히 설정한다.

[systemd-boot]: https://wiki.archlinux.org/index.php/Systemd-boot

## 재부팅
끝! 재부팅하자. gdm이 반겨줄 것이다.

재부팅한 뒤에도 시각 동기화가 되는지 모르겠다.

## GNOME 꾸미기
이것들이 있으면 충분할 것이다.

- Adapta 테마
- Papirus 아이콘 테마
- Dash to Dock
- No topleft hot corner
- Topicons plus
