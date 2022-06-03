######################################################################
### RISC-V Vector Extension - Installer for Compiler and Simulator ###
######################################################################

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RED='\033[1;31m'
BG_RED='\033[0;101m'
NC='\033[0m' # No Color

printf """
${GREEN}    RISC-V Vector Extension - Installer for Compiler and Simulator${NC}

${WHITE}                            Ha How Ung (2022)${NC}

"""

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
sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev -y
cd riscv-gnu-toolchain_rvv
mkdir build
cd build
make clean
../configure --prefix=$HOME/local/riscv_v/gnu --enable-multilib
make
export PATH=$HOME/local/riscv_v/gnu/bin:$PATH
cd ../..

# Install spike simulator
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
sudo apt-get install device-tree-compiler -y
cd riscv-isa-sim
mkdir build
cd build
make clean
../configure --prefix=$HOME/local/riscv_v/spike
make
make install
export PATH=$HOME/local/riscv_v/spike/bin:$PATH
cd ../..

# Install pk (proxy kernel)
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
cd riscv-pk
mkdir build
cd build
make clean
../configure --prefix=$HOME/local/riscv_v/pk --host=riscv64-unknown-elf
make
make install
export PATH=$HOME/local/riscv_v/pk/riscv64-unknown-elf/bin:$PATH
cd ../..

# Add RISCV shell variable for ease of access
export RISCV=$HOME/local/riscv_v

# Activate the shortcuts
source RVV_cmd.sh

# Add lines to .bashrc file
cp $HOME/.bashrc $HOME/.bashrc.bak
sudo cp /root/.bashrc /root/.bashrc.bak
sudo echo "export PATH=${HOME}/local/riscv_v/gnu/bin:${HOME}/local/riscv_v/spike/bin:${HOME}/local/riscv_v/pk/riscv64-unknown-elf/bin:${PATH}" | tee -a /root/.bashrc $HOME/.bashrc
sudo echo "export RISCV=${HOME}/local/riscv_v" | tee -a /root/.bashrc $HOME/.bashrc
sudo echo "source ${PWD}/RVV_cmd.sh" | tee -a /root/.bashrc $HOME/.bashrc

# Ending message
if command -v riscv64-unknown-elf-gcc > /dev/null && command -v spike > /dev/null && command -v pk > /dev/null
then
    printf """


    ${GREEN}                        INSTALLATION COMPLETE!${NC}

    ${WHITE}                                Usage:${NC}

    rvv64-compile\t<C/RISC-V script>\t\t\t- Compile the C/RISC-V script
    rvv64-run\t<RISC-V binary file>\t\t\t- Run simulation using the compiled RISC-V
    rvv64-link\t<main script> <RISC-V function script>\t- Compile with a main script that calls the function written in RISC-V
    """
else
    printf """
    ${RED}Installation incomplete. Something went wrong.${NC}
    """
fi
