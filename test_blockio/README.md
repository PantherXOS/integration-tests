# BlockIO Integration Test 

This test is for px-accounts-service-plugin-blockio and px-accounts-service-plugin-cryptocurrency

## Parameters:
- api_key (Blockio)
- name (Cryptocurrency)
- address (Cryptocurrency)
- curr_type (Cryptocurrency)

## Available Tests:
- Create Blockio Account
- Check Blockio Account 
- Create Bitcoin Account
- Modify Bitcoin Account
- Remove Bitcoin Account

## How to run tests: 
In order to run test on PantherX core image, you need to run :
- `prerequisites.sh` to install dependencies
- `run.sh` to run test
```bash
$ root@panther ~/integration-tests/test_blockio# ./prerequisites.sh"
```
```bash
$ root@panther ~/integration-tests/test_blockio# ./run.sh"
```

