#################################################################
### RISC-V Vector Extension - Compiler and Simulator commands ###
#################################################################

YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

if [ -z ${RISCV+x} ]; then export RISCV=$HOME/local/riscv_v; fi

rvv64-compile(){
    file=$1
    fileName=${file%.*}
    $RISCV/gnu/bin/riscv64-unknown-elf-gcc -march=rv64gcv $file -o $fileName.o
    printf ">> Output binary generated as ${fileName}.o\n"
}

rvv64-run(){
    $RISCV/spike/bin/spike --isa=RV64gcv $RISCV/pk/riscv64-unknown-elf/bin/pk $1
}

rvv64-link(){
    mainFile=$1
    riscvFile=$2
    riscvFileName=${riscvFile%.*}
    $RISCV/gnu/bin/riscv64-unknown-elf-as -march=rv64gcv $riscvFile -o $riscvFileName
    $RISCV/gnu/bin/riscv64-unknown-elf-gcc $mainFile $riscvFileName -o $riscvFileName.o
    rm $riscvFileName
    printf ">> Output binary generated as ${riscvFileName}.o\n"
}

rvv64-help(){
    printf """
${YELLOW}                   RISC-V Vector Extension - Compiler and Simulator${NC}

${WHITE}                                    Ha How Ung (2022)${NC}

${WHITE}                                        Usage:${NC}

rvv64-help\t\t\t\t\t\t- Show this help menu
rvv64-compile\t<C/RISC-V script>\t\t\t- Compile the C/RISC-V script
rvv64-run\t<RISC-V binary file>\t\t\t- Run simulation using the compiled RISC-V
rvv64-link\t<main script> <RISC-V function script>\t- Compile with a main script that calls the function written in RISC-V"""
}
