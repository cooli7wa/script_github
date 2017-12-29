#!/bin/bash -

function echo_color
{
    local color=$1
    local message=$2
    local pre_color=""
    local post_color='\033[0m'

    case "$color" in
    RED)
        pre_color='\033[31m';;
    GREEN)
        pre_color='\033[32m';;
    YELLOW)
        pre_color='\033[33m';;
    BLUE)
        pre_color='\033[34m';;
    NO)
        pre_color='\033[0m';;
    *)
        pre_color='\033[0m';;
    esac

    echo -e $pre_color$message$post_color
}


packages="vim zlib1g-dev:i386 g++-multilib ssh make gawk g++ binutils pkg-config synaptic terminator ant u-boot-tools gperf bison doxygen libswitch-perl libxml2-utils libssl-dev xsel adb git sshfs repo curl"

echo_color RED "apt-get update .."
sudo apt-get update

echo_color RED "apt-get install .."
sudo apt-get install -y $packages

echo_color RED "install openjdk-8 .. (1604 don't need)"

echo_color RED "install chrome .."
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo_color RED "install sogou .."
sudo dpkg -i sogoupinyin_2.2.0.0102_amd64.deb
echo_color YELLOW "please config next: \"im-config\" \"fcitx-config-gtk3\""

echo_color RED "install needed libraries before.."
sudo apt-get install -f -y

echo_color RED "config bashrc inputrc vimrc .."

echo_color RED "generate sshkey .."
sudo ssh-keygen
cat ~/.ssh/id_rsa.pub
