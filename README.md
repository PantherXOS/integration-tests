# PantherX Applications Integration Tests

This repository contains a series of integration tests, for PantherX Applications. 

## Available Tests:
- Test IMAP related services. 


## How to run tests: 
In order to run each test remotely on PantherX core image, you need to run `remote-test-runner.sh` script with target test file name. for example for **IMAP related test**, test executions could be as follows: 

```bash
$ ./remote-test-runner.sh "./test-imap/imap-test.sh"
```

**Note 1:** it is recommended to add your ssh key to target machine to prevent asking passwords during test execution. 