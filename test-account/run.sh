# ==================================================
DONE='[\033[1;32mDONE\033[0m]'
FAIL='[\033[1;31mFAIL\033[0m]'

LOG_PATH="./logs"
GENERAL_LOG="$LOG_PATH/general.log"
NO_DEPENDENCY=0
DEBUG=0
# ==================================================
parse_input() {
    for param in $@; do
        case "$param" in
        "--no-dependency")
            NO_DEPENDENCY=1
            ;;
        "--debug")
            DEBUG=1
            ;;
        *)
            ;;
        esac
    done;
}
# ==================================================
LOG_DBG() {
    filename="$1"
    data=($@)
    data="${data[@]:1}"
    if [ $DEBUG -eq 1 ]; then
        echo $data | tee -a $filename
    else
        echo $data > $filename
    fi
}
# ==================================================
cleanup() {
    if [ -d $LOG_PATH ]; then 
        backup_path="$LOG_PATH-$(date +'%s')" 
        mv $LOG_PATH $backup_path
        mkdir -p $LOG_PATH
        echo "> Cleanup Old Test Log:" | tee -a $GENERAL_LOG
        echo "     - backup old logs to: $backup_path" | tee -a $GENERAL_LOG
    fi
    mkdir -p $LOG_PATH
}
# ==================================================
install_dependency () {
    echo -n "     - installing $1 " | tee -a $GENERAL_LOG
    res="$(guix package -i $1 2>&1)"
    ret="$?"
    if [  $ret -eq 0 ]; then
        printf "$DONE\n" | tee -a $GENERAL_LOG
    else
        printf "$FAIL\n" | tee -a $GENERAL_LOG
        echo $res | tee -a $GENERAL_LOG
    fi
    return $ret
}
# ==================================================
install_dependencies () {
    echo "> Installing Test Dependencies: " | tee -a $GENERAL_LOG
    deps=("$@")
    for dep in "${deps[@]}"; do
        install_dependency $dep
        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
}
# ==================================================
run_service() {
    IFS='
    '
    service=$1
    echo -n "     - $1" | tee -a $GENERAL_LOG
    for pid in $(ps x | grep -v grep | grep "$service" | awk '{print $1}'); do 
        printf " - killing $pid";  
        kill -9 $pid; 
    done;
    IFS=
    "$service" -d > "$LOG_PATH/$service.log" 2>&1 &
    printf " $DONE\n"
}
# ==================================================
run_services() {
    echo "> Run Required Services:"
    services=("$@")
    for svc in "${services[@]}"; do
        run_service $svc
    done
}
# ==================================================
run_test () {
    filename=$(basename -- "$1")
    test_ext="${filename##*.}"
    test_name="${filename%.*}"

    echo -n "     - running $test_name " | tee -a $GENERAL_LOG
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
        printf "$DONE\n" | tee -a $GENERAL_LOG
    else 
        printf "$FAIL\n" | tee -a $GENERAL_LOG
    fi
    LOG_DBG "$LOG_PATH/$test_name.log" $res
    return $ret
}
# ==================================================
run_tests () {
    tests=("$@")
    echo "> Running Test Scripts:" | tee -a $GENERAL_LOG
    for test in "${tests[@]}"; do
        run_test $test
    done
}
# ==================================================
main () {
    echo "Online Accounts Test Procedure"
    echo "========================================"
    
    dependencies=("python"
                  "python-pycapnp"
                  "px-accounts-service"
                  "px-accounts-service-plugin-etherscan"
                  "px-accounts-service-plugin-cryptocurrency"
                  "px-events-service"
                  "px-secret-service")

    services=("px-accounts-service"
              "px-secret-service"
              "px-events-service")
    
    tests=($(ls test-*))
    IFS=
    
    
    # ......................
    cleanup 
    if [ $NO_DEPENDENCY -eq 0 ]; then
        install_dependencies "${dependencies[@]}"
        if [ $? -ne 0 ]; then 
            exit
        fi
    fi
    run_services "${services[@]}";
    run_tests "${tests[@]}";
}
# ==================================================
rm -rf logs-*
parse_input $@

main
