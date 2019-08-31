
declare -a packages
tests=(
    "test_smtp"
    # "test_imap"
    "test_etherscan"
    # "test_blockio"
    # "test-backup"
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

echo ""
echo ">>> Execute Tests: "
for test in "${tests[@]}"; do
    echo "$test";
    cd "$test"
    sh run.sh
    cd ..
done
