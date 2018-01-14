#!/bin/bash

#################################################################################
#										#
#	i3 config install script - intended for use on Ubuntu and derivatives	#
#										#
#################################################################################

#startup message
echo "preparing to install /u/Dexger's i3 config. You are running this in a terminal!" && notify-send "preparing to install /u/Dexger's i3 config Please run this script from the terminal" && sleep 1

#install preliminary dependencies + dunst dependencies
echo "installing various dependencies"
sudo apt-get install git libinput p7zip-full unrar wget curl 
libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk2.0-dev libxdg-basedir-dev compton libinput i3lock feh lxappearance scrot rofi amixer alsamixer alsa lolcat nm-applet

#install polybar dependencies
sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libxcb-cursor-dev

#install tilix terminal emulator
sudo apt-get install tilix

#install i3-gaps dependencies
sudo apt-get install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake dunst

#install icon font for polybar (fontawesome)
sudo apt-get install fonts-font-awesome

#resolve any unmet dependencies
sudo apt-get install -f

#compile & install i3-gaps window manager
echo "compiling and installing i3-gaps window manager"
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd

#compile & install dunst notification daemon
echo "compiling and installing dunst notification daemon"
git clone https://github.com/dunst-project/dunst.git
cd dunst
make
sudo make install
cd

#compile & install polybar
echo "compiling and installing polybar"
git clone --branch 3.1.0 --recursive https://github.com/jaagr/polybar
echo "POLYBAR BUILD CONFIG - SELECT MODULES YOU WOULD LIKE ENABLED. ALSA IS REQUIRED FOR THIS CONFIG TO WORK" | lolcat && sleep 2
cd polybar
./build.sh
cd
mkdir polybar/build
cd polybar/build
cmake ..
sudo make install
cd

#create required directories
mkdir ~/.config/polybar/
mkdir ~/.i3/

#touchpad tap to click
echo "would you like to add tap to click support for touchpads? (this modifies xorg.conf) please ensure that you have no InputClass Section already present in xorg.conf if you wish to apply this setting"
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        sudo touch /etc/X11/xorg.conf && sudo echo 'Section "InputClass"
        Identifier "10"
        MatchIsTouchpad "on"
        Driver "libinput"
    Option "Tapping" "on"
 ###   Option "AccelSpeed" "1.0"
Option "HorizHysteresis" "20"
    Option "VertHysteresis" "20"
    Option "FingerLow" "10"
    Option "FingerHigh" "20"
    
EndSection' >> /etc/X11/xorg.conf
        ;;
    *)
        echo "xorg.conf was not changed" && sleep 1
        ;;
esac

#clone my repository
git clone https://github.com/Dexger/i3rice.git

#set up i3 config
cp ~/i3rice/config ~/.i3/

#set up dunst config
cp ~/i3rice/.dunstrc ~/

#set up compton config
cp ~/i3rice/compton.conf ~/.config/

#set up polybar config
cp ~/i3rice/dexger ~/.config/polybar/

#remove min/max/close buttons from csd
echo "Would you like to remove min/max/close buttons from gtk3 apps? This can be easily rectified later, but may be undesirable if you plan to use a stacking WM as well as i3."
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        touch ~/.config/gtk-3.0/settings.ini && echo 'gtk-decoration-layout=appmenu' >> ~/.config/gtk-3.0/settings.ini
        ;;
    *)
        echo "gtk-3.0 config was unchanged" && sleep 1
        ;;
esac

echo "install complete, selecting i3 from your display manager will now use new configs." && echo "exiting..." && sleep 1 && exit

