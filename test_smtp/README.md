# IMAP Integration Test 

This test is for px-accounts-service-plugin-protocol-imap

## Parameters:
- sender
- receivers
- host
- username
- password
- port
- message

## Available Tests:
- Create IMAP Account
- Modify IMAP Account
- Remove IMAP Account

## How to run tests: 
In order to run test on PantherX core image, you need to run :
- `prerequisites.sh` to install dependencies
- `run.sh` to run test
```bash
$ root@panther ~/integration-tests/test_etherscan# ./prerequisites.sh
```
```bash
$ root@panther ~/integration-tests/test_etherscan# ./run.sh
```

