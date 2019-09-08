# Integration test implementation for PantherX Applications

In order to write _Integration Tests_ for PantherX applications, we use  [bats-core](https://github.com/bats-core/bats-core) framework. _Bats-core_ is a testing framework for bash. If you want to write new tests, first you need to get familiar with that. for this you can follow their official [documents](https://github.com/bats-core/bats-core).

## Test Suite Structure

Each test suite is a folder located on [integration-tests](https://git.pantherx.org/development/integration-tests) repository. Test folders need to have following specifications:

- Each test needs to have a `prerequisites.sh` script. we need to install required packages that our test is dependent on in this script. it's mostly just a simple `guix package --install ...` script.

- Starting point for each test suite to run is the `run.sh` script. the order of tasks needs to be performed in this file is:

  1. cleanup old test execution results
  2. run applications that are required to run test-suite
  3. execute `bsts .`  command to run all existing tests in current folder
  4. kill opened applications we had run prior to test execution

- We also need to write our test scripts in files with `.bats.` extension in order to allow _bats-core_ to execute them.

## Add Test Suite to Execution List

in order to add a _Test Suite_ to execution list we need to modify [`integration-tests.sh`](https://git.pantherx.org/development/integration-tests/blob/master/integration-tests.sh "integration-tests.sh") script and add its folder name to `tests` array:

```bash
tests=("test_smtp"
       "test_imap"
       "test_etherscan"
       "your-test-goes-here"
      ....)
```

## Run Tests

In order to run tests we just need to run  [`integration-tests.sh`](https://git.pantherx.org/development/integration-tests/blob/master/integration-tests.sh "integration-tests.sh") script using bash.

```shell
sh integration-tests.sh
```

Executing this script, first we update _Guix Package Repository_, then all required applications that are defined in `prerequisites.sh` files are installed. and later we execute `run.sh` script one by one and print test execution results. we also receive an overall test result after executing all tests:

```shell
Overall Test Results:
----------------------------------------
Total: 63
Success: 58
Skip: 5
Fail: 0
----------------------------------------
```
