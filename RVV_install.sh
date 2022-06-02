######################################################################
### RISC-V Vector Extension - Installer for Compiler and Simulator ###
######################################################################

# Install riscv-gnu-toolchain
# Copyright - RISC-V Software Collaboration (https://github.com/riscv-collab)
cd riscv-gnu-toolchain_rvv
mkdir build
cd build
../configure --prefix=$HOME/local/riscv_v/gnu --enable-multilib
make
export PATH=$HOME/local/riscv_v/gnu/bin:$PATH

cd ..

# Install spike simulator
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
cd riscv-isa-sim
mkdir build
cd build
../configure --prefix=$HOME/local/riscv_v/spike
make
make install
export PATH=$HOME/local/riscv_v/spike/bin:$PATH

cd ..

# Install pk (proxy kernel)
# Copyright - RISC-V Software (https://github.com/riscv-software-src)
cd riscv-pk
mkdir build
cd build
../configure --prefix=$HOME/local/riscv_v/pk --host=riscv64-unknown-elf
make
make install
export PATH=$HOME/local/riscv_v/pk/riscv64-unknown-elf/bin:$PATH

# Add RISCV shell variable for ease of access
export RISCV=$HOME/local/riscv_v

# Activate the shortcuts
source RVV_cmd.sh

# Ending message
printf """
INSTALLATION COMPLETE!

Usage:

rvv64-compile\t<C/RISC-V script>\t\t\t- Compile the C/RISC-V script
rvv64-run\t<RISC-V binary file>\t\t\t- Simulate the compiled RISC-V
rvv64-link\t<main script> <RISC-V function script>\t- Compile with a main script that calls the function written in RISC-V
"""