######################################################################
### RISC-V Vector Extension - Installer for Compiler and Simulator ###
######################################################################

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RED='\033[1;31m'
BG_RED='\033[0;101m'
BG_BLUE='\033[0;104m'
BG_GREEN='\033[0;102m'
NC='\033[0m' # No Color

printf """
${GREEN}            RISC-V Vector Extension - Installer for Compiler and Simulator${NC}

${WHITE}                                    Ha How Ung (2022)${NC}

"""

if [ $UID -eq 0 ]
then
    printf "${BG_RED}Please DO NOT run this code as root! Please login and re-run as non-root user or please DO NOT use sudo!${NC}\n\n"
    exit
fi

if command -v riscv64-unknown-elf-gcc > /dev/null && command -v spike > /dev/null && command -v pk > /dev/null
then
    printf """
${YELLOW}Seems like you have already installed this program.
Do you wish to reinstall it? [Y/n]${NC} """
    while true; do
        read -p "" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) printf "${YELLOW}[Y/n]${NC} ";;
        esac
    done
fi

printf """
${BG_RED}Some parts of the installation requires sudo login. Please type your password whenever prompted.${NC}
"""

# Install riscv-gnu-toolchain
# Copyright - RISC-V Software Collaboration (https://github.com/riscv-collab)
 > RVV_path.sh
printf '\nPATH=$HOME/local/riscv_v/gnu/bin:$PATH' > RVV_path.sh
source RVV_path.sh

if ! command -v riscv64-unknown-elf-gcc > /dev/null # If RISC-V GNU Toolchain is not found
then
    printf "\n${BG_BLUE}Installing RISC-V GNU Toolchain.${NC}\n"
    sudo apt-get -qq install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev -y
    cd riscv-gnu-toolchain_rvv
    mkdir build
    cd build
    make clean > /dev/null || make clean
    ../configure --prefix=$HOME/local/riscv_v/gnu --enable-multilib
    printf "${WHITE}Installing ... "
    make >/dev/null || make
     > RVV_path.sh
    printf '\nPATH=$HOME/local/riscv_v/gnu/bin:$PATH' > RVV_path.sh
    source RVV_path.sh
    cd ../..

    if ! command -v riscv64-unknown-elf-gcc > /dev/null
    then
        printf "\n${RED}Installation of RISC-V GNU Toolchain failed. Aborting.${NC}\n"
        exit
    else
        printf "\n${BG_GREEN}RISC-V GNU Toolchain install complete.${NC}\n"
    fi
else
    printf "\n${BG_GREEN}RISC-V GNU Toolchain is already installed.${NC}\n"
fi

# Install spike simulator
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
 > RVV_path.sh
printf '\nPATH=$HOME/local/riscv_v/spike/bin:$PATH' > RVV_path.sh
source RVV_path.sh

if ! command -v spike > /dev/null # If Spike is not found
then
    printf "\n${BG_BLUE}Installing Spike RISC-V ISA Simulator.${NC}\n"
    sudo apt-get -qq install device-tree-compiler -y
    cd riscv-isa-sim
    mkdir build
    cd build
    make clean > /dev/null || make clean
    ../configure --prefix=$HOME/local/riscv_v/spike --enable-silent-rules
    printf "${WHITE}Installing ... "
    make > /dev/null || make
    make install > /dev/null || make install
     > RVV_path.sh
    printf '\nPATH=$HOME/local/riscv_v/spike/bin:$PATH' > RVV_path.sh
    source RVV_path.sh
    cd ../..

    if ! command -v spike > /dev/null
    then
        printf "\n${RED}Installation of Spike RISC-V ISA Simulator failed. Aborting.${NC}\n"
        exit
    else
        printf "\n${BG_GREEN}Spike RISC-V ISA Simulator install complete.${NC}\n"
    fi
else
    printf "\n${BG_GREEN}Spike RISC-V ISA Simulator is already installed.${NC}\n"
fi

# Install pk (proxy kernel)
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
 > RVV_path.sh
printf '\nPATH=$HOME/local/riscv_v/pk/riscv64-unknown-elf/bin:$PATH' > RVV_path.sh
source RVV_path.sh

if ! command -v pk > /dev/null # If proxy kernel (pk) is not found
then
    printf "\n${BG_BLUE}Installing proxy kernel (pk).${NC}\n"
    cd riscv-pk
    mkdir build
    cd build
    make clean > /dev/null || make clean
    ../configure --prefix=$HOME/local/riscv_v/pk --host=riscv64-unknown-elf
    make > /dev/null || make
    make install > /dev/null || make install
     > RVV_path.sh
    printf '\nPATH=$HOME/local/riscv_v/pk/riscv64-unknown-elf/bin:$PATH' > RVV_path.sh
    source RVV_path.sh
    cd ../..

    if ! command -v pk > /dev/null
    then
        printf "\n${RED}Installation of proxy kernel (pk) failed. Aborting.${NC}\n"
        exit
    else
        printf "\n${BG_GREEN}Proxy kernel (pk) install complete.${NC}\n"
    fi
else
    printf "\n${BG_GREEN}Proxy kernel (pk) is already installed.${NC}\n"
fi

# Save RISC-V paths to a file
printf """
PATH=$HOME/local/riscv_v/gnu/bin:$HOME/local/riscv_v/spike/bin:$HOME/local/riscv_v/pk/riscv64-unknown-elf/bin:$PATH
RISCV=$HOME/local/riscv_v
""" > RVV_path.sh

# Back up the .bashrc files
cp $HOME/.bashrc $HOME/.bashrc.bak
sudo cp /root/.bashrc /root/.bashrc.bak

# source RISC-V paths and utilities from the .bashrc scripts
sudo printf """
source ${PWD}/RVV_path.sh
source ${PWD}/RVV_cmd.sh""" | sudo tee -a $HOME/.bashrc /root/.bashrc

# Ending message
if command -v riscv64-unknown-elf-gcc > /dev/null && command -v spike > /dev/null && command -v pk > /dev/null
then
    printf """


${GREEN}                        INSTALLATION COMPLETE!${NC}

${WHITE}                                Usage:${NC}

rvv64-help\t\t\t\t\t\t- Show this help menu
rvv64-compile\t<C/RISC-V script>\t\t\t- Compile the C/RISC-V script
rvv64-run\t<RISC-V binary file>\t\t\t- Run simulation using the compiled RISC-V
rvv64-link\t<main script> <RISC-V function script>\t- Compile with a main script that calls the function written in RISC-V
"""
else
    printf """
${RED}Installation incomplete. Something went wrong.${NC}
"""
fi

# reload bash
exec bash
