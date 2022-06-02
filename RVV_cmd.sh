
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