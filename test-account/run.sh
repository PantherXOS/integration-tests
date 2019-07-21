

# ==================================================
DONE='\033[1;32mDONE\033[0m'
FAIL='\033[1;31mFAIL\033[0m'

LOG_PATH="./logs"
DEP_LOG="$LOG_PATH/dependency.log"
# ==================================================
cleanup() {
    echo "> Cleanup Old Test Log:"
    rm -rf $LOG_PATH
    mkdir -p $LOG_PATH
}
# ==================================================
install_dependency () {
    echo -n "     - $1 "
    res="$(guix package -i $1 2>&1)"
    ret="$?"
    if [  $ret -eq 0 ]; then
        printf "\t$DONE\n" 
    else
        printf "\t$FAIL\n"
        echo $res
    fi
    echo $res >> $DEP_LOG;
    return $ret
}
# ==================================================
install_dependencies () {
    echo "> Installing Test Dependencies: "
    echo "INSTALL DEPENDENCIES" > $DEP_LOG;
    deps=("$@")
    for dep in "${deps[@]}"; do
        echo "========================================" >> $DEP_LOG;
        echo $dep >> $DEP_LOG;
        install_dependency $dep
        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
}
# ==================================================
run_test () {
    filename=$(basename -- "$1")
    test_ext="${filename##*.}"
    test_name="${filename%.*}"

    echo -n "     - $test_name "
    res=""
    ret=0
    if [[ $test_ext == "sh" ]]; then 
        res=$(sh $filename 2>&1)
        ret=$?
    elif [[ $test_ext == "py" ]]; then
        res=$(python3 $filename 2>&1)
        ret=$?
    else
        res="script extension ($test_ext) is not supported."
        ret=1
    fi

    if [ $ret -eq 0 ]; then
        printf "\t$DONE\n"
    else 
        printf "\t$FAIL\n" 
    fi
    return $ret
}
# ==================================================
run_tests () {
    echo "> Running Test Scripts:"
    tests=$1
    for test in "${tests[@]}"; do 
        run_test $test;
    done
}
# ==================================================
main () {
    echo "Online Accounts Test Procedure"
    echo "========================================"
    
    dependencies=("python"
                  "px-accounts-service"
                  "px-events-service"
                  "px-secret-service")
    
    tests=($(ls test-*))
    
    # ......................
    cleanup
    # install_dependencies "${dependencies[@]}"
    if [ $? -ne 0 ]; then 
        exit
    fi
    run_tests $tests;
}
# ==================================================
main
