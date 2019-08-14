# Etherscan Integration Test 

This test is for px-accounts-service-plugin-etherscan and px-accounts-service-plugin-cryptocurrency

## Parameters:
- api_key (Etherscan)
- name (Cryptocurrency)
- address (Cryptocurrency)
- curr_type (Cryptocurrency)

## Available Tests:
- Create Etherscan Account
- Check Etherscan Account 
- Create Ethereum Account
- Modify Ethereum Account
- Remove Ethereum Account

## How to run tests: 
In order to run test on PantherX core image, you need to run :
- `prerequisites.sh` to install dependencies
- `run.sh` to run test
```bash
$ root@panther ~/integration-tests/test_etherscan# ./prerequisites.sh"
```
```bash
$ root@panther ~/integration-tests/test_etherscan# ./run.sh"
```

