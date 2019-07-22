# ==================================================
DONE='\033[1;32mDONE\033[0m'
FAIL='\033[1;31mFAIL\033[0m'

LOG_PATH="./logs"
GENERAL_LOG="$LOG_PATH/general.log"
# ==================================================
cleanup() {
    echo "> Cleanup Old Test Log:"
    if [ -d $LOG_PATH ]; then 
        backup_path="$LOG_PATH-$(date +'%s')" 
        mv $LOG_PATH $backup_path
        mkdir -p $LOG_PATH
        touch $GENERAL_LOG
        echo "     - backup old logs to: $backup_path" | tee $GENERAL_LOG
    fi
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
    echo $res >> $GENERAL_LOG;
    return $ret
}
# ==================================================
install_dependencies () {
    echo "> Installing Test Dependencies: "
    echo "INSTALL DEPENDENCIES" > $GENERAL_LOG;
    deps=("$@")
    for dep in "${deps[@]}"; do
        echo "========================================" >> $GENERAL_LOG;
        echo $dep >> $GENERAL_LOG;
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
