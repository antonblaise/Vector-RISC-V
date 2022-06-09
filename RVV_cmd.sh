#################################################################
### RISC-V Vector Extension - Compiler and Simulator commands ###
#################################################################

YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

if [ -z ${RISCV+x} ]; then export RISCV=$HOME/local/riscv_v; fi

rvv64-compile(){
    if [ $# -eq 0 ]
    then
        rvv64-help
    else
        file=$2
        if [[ -v file ]]
        then
            fileName=${file%.*}
            case "$1" in
                -v|--vector) # Compile in RISC-V Vector ISA
                    printf "\n${WHITE}Vector${NC}\n\n"
                    run_start=$(date +%s%N)
                    $RISCV/gnu/bin/riscv64-unknown-elf-gcc -march=rv64gcv $file -o $fileName-v.o
                    run_end=$(date +%s%N)
                    fileName="${fileName}-v"
                    printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
                -s|--scalar) # Compile in RISC-V Scalar ISA
                    printf "\n${WHITE}Scalar${NC}\n\n"
                    run_start=$(date +%s%N)
                    $RISCV/gnu/bin/riscv64-unknown-elf-gcc -march=rv64gcv $file -o $fileName-s.o
                    run_end=$(date +%s%N)
                    fileName="${fileName}-s"
                    printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
                --)
                    break;;
                *) # Default = Vector
                    file=$1
                    fileName=${file%.*}
                    run_start=$(date +%s%N)
                    $RISCV/gnu/bin/riscv64-unknown-elf-gcc -march=rv64gcv $file -o $fileName-v.o
                    run_end=$(date +%s%N)
                    fileName="${fileName}-v"
                    printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
            esac
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
        case "$1" in
            -v|--vector)
                printf "\n${WHITE}Vector${NC}\n\n"
                run_start=$(date +%s%N)
                $RISCV/spike/bin/spike --isa=RV64gcv $RISCV/pk/riscv64-unknown-elf/bin/pk $2
                run_end=$(date +%s%N)
                printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
            -s|--scalar)
                printf "\n${WHITE}Scalar${NC}\n\n"
                run_start=$(date +%s%N)
                $RISCV/spike/bin/spike --isa=RV64gc $RISCV/pk/riscv64-unknown-elf/bin/pk $2
                run_end=$(date +%s%N)
                printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
            --)
                break;;
            *)
                run_start=$(date +%s%N)
                $RISCV/spike/bin/spike --isa=RV64gcv $RISCV/pk/riscv64-unknown-elf/bin/pk $1
                run_end=$(date +%s%N)
                printf "\n${WHITE}Elapsed time: ${PURPLE}$(($run_end-$run_start)) nanoseconds${NC}\n\n";;
        esac
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
