#################################################################
### RISC-V Vector Extension - Compiler and Simulator commands ###
#################################################################

YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

if [ -z ${RISCV+x} ]; then export RISCV=$HOME/local/riscv_v; fi

rvv64-compile(){
    if [ $# -eq 0 ]
    then
        rvv64-help
    else
        file=$1
        if [[ -v file ]]
        then
            fileName=${file%.*}
            $RISCV/gnu/bin/riscv64-unknown-elf-gcc -march=rv64gcv $file -o $fileName.o
            if [ -f "$fileName.o" ]; then
                printf "\n${WHITE}>> Output binary generated as ${YELLOW}${fileName}.o${NC}\n\n"
            fi
        else
            printf ">> No input file.\n"
        fi
    fi
}

rvv64-run(){
    if [ $# -eq 0 ]
    then
        rvv64-help
    else
        $RISCV/spike/bin/spike --isa=RV64gcv $RISCV/pk/riscv64-unknown-elf/bin/pk $1
    fi
}

rvv64-link(){
    if [ $# -eq 0 ]
    then
        rvv64-help
    else
        mainFile=$1
        riscvFile=$2
        if [[ -v mainFile ]] && [[ -v riscvFile ]]
        then
            riscvFileName=${riscvFile%.*}
            $RISCV/gnu/bin/riscv64-unknown-elf-as -march=rv64gcv $riscvFile -o $riscvFileName
            $RISCV/gnu/bin/riscv64-unknown-elf-gcc $mainFile $riscvFileName -o $riscvFileName.o
            rm $riscvFileName
            if [ -f "$riscvFileName.o" ]; then
                printf "\n${WHITE}>> Output binary generated as ${YELLOW}${riscvFileName}.o${NC}\n\n"
            fi
        else
            printf ">> Some input files are missing.\n"
        fi
    fi
}

rvv64-help(){
    printf """
${YELLOW}                   RISC-V Vector Extension - Compiler and Simulator${NC}

${WHITE}                                    Ha How Ung (2022)${NC}

${WHITE}                                        Usage:${NC}

rvv64-help\t\t\t\t\t\t- Show this help menu
rvv64-compile\t<C/RISC-V script>\t\t\t- Compile the C/RISC-V script
rvv64-run\t<RISC-V binary file>\t\t\t- Run simulation using the compiled RISC-V
rvv64-link\t<main script> <RISC-V function script>\t- Compile with a main script that calls the function written in RISC-V
"""
}
