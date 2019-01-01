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


packages="vim zlib1g-dev:i386 g++-multilib ssh make gawk g++ binutils pkg-config synaptic terminator ant u-boot-tools gperf bison doxygen libswitch-perl libxml2-utils libssl-dev xsel adb git sshfs repo curl cmake cmake-curses-gui"

echo_color YELLOW "== begin to install necessary cmds and libraries =="

echo_color BLUE "apt-get update .."
sudo apt-get update

echo_color BLUE "apt-get install .."
sudo apt-get install -y $packages

echo_color BLUE "install needed libraries before.."
sudo apt-get install -f -y

echo_color BLUE "generate sshkey .."
sudo ssh-keygen
cat ~/.ssh/id_rsa.pub

echo_color YELLOW "== something todo =="
echo_color BLUE "1. config bashrc inputrc vimrc"
echo_color BLUE "2. config vim"
echo_color BLUE "3. config github sshkey"
echo_color BLUE "4. docker"
