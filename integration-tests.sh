
declare -a packages
tests=(
    "test_smtp"
    "test_imap"
    "test_etherscan"
       # "test_blockio"
    "test-backup"
    "test-account"
    "test-event"
    "test-secret"
    "test-settings"
    "test-settings-plugin-account"
    "test-setup"
    "test-status-service"
    )


echo ""
echo ">>> Update Package Repository:"
guix pull

echo ""
echo ">>> Install Dependencies:"
for test in "${tests[@]}"; do
    if [ -e "$test/prerequisites.sh" ]; then
        result=$(sh "$test/prerequisites.sh" 2>&1)

        plines=$(echo "$result" | grep -E "^   [a-z\-]+$(printf '\t')v?[0-9\.]+" | grep -Eo "^   [a-z\-]+$(printf '\t')" ) 
        while  read -r line; do
            found=0
            for p in "${packages[@]}"; do
                [ "$line" == "$p" ] && found=1;
            done
            if [ $found -ne 1 ]; then 
                packages+=("$line");
                echo "   - $line";
            fi
        done <<<$plines;
    else
        echo "WARNING: 'prerequisites.sh' NOT FOUND";
    fi
done

GUIX_PROFILE="/root/.config/guix/current" . "$GUIX_PROFILE/etc/profile"

echo ""
echo ">>> Execute Tests: "
total=0
success=0
skip=0
fail=0
exec {stdout_copy}>&1
for test in "${tests[@]}"; do
    echo "$test";
    cd "$test"
    result=$(sh run.sh | tee /dev/fd/"$stdout_copy")
    echo '----------------------------------------'
    cd ..

    cnt_total=$(echo "$result" | grep -E "^(not )?ok [0-9]+" | wc -l)
    cnt_success=$(echo "$result" | grep -E "^ok [0-9]+" | wc -l)
    cnt_skip=$(echo "$result" | grep -E "^ok [0-9]+" | grep -E "# skip" | wc -l)
    cnt_fail=$(echo "$result" | grep -E "^not ok [0-9]+" | wc -l)
    total=$(($total+$cnt_total))
    success=$(($success+$cnt_success-$cnt_skip))
    skip=$(($skip+$cnt_skip))
    fail=$(($fail+$cnt_fail))
done
exec {stdout_copy}>&-
echo ""
echo "Overall Test Results:"
echo '----------------------------------------'
echo "Total: $total"
echo "Success: $success"
echo "Skip: $skip"
echo "Fail: $fail"
echo '----------------------------------------'
