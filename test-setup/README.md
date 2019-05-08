# `px-setup-assistant` Tests
This _shell_ script developed for run tests of `px-setup-assistant` automatically.

## Test 1
In this step, the `px-setup-assistant` run in _Command Line Mode_ and recieves the needed parameters as argument:
```
-u username
-g group
-c comment
-h hostname
-t timezone
-l locale
```

```shell
px-setup-assistant -p desktop -u $user -g $group -t $tz -l $locale -c "$comment" -H $hostname -d debug -r true
```


### Sequence
1. Package installation    
   * Installing `px-lib-rw-guix-config` library
   * Installing `px-setup-assistant` package
   
2. Running `px-setup-assistant`    
   run `setup` with the following parameters:
```shell
user=hamzeh
group=users
tz=Asia/Tehran
locale=en_US.utf8
comment="no comment"
hostname=GUIX$user
px-setup-assistant -p desktop -u $user -g $group -t $tz -l $locale -c "$comment" -H $hostname -d debug -r true > setup-1.log 2>&1
```
   `px-setup-assistant` run, generate `new-config.scm` and run the `quix system reconfigure new-config.scm`.
   
3. Check output    
   If everythings goes well the user created and the system parameters (hostname, timezone, locale) will be updated.     
   In this step _shell_ checks the `new-config.scm` and home user are available or no.


### Example (OK output)
```shell
root@panther ~/panther/integration-tests/test-setup# ./test.sh
-------------------------------------------------
            px-setup-assistant test
-------------------------------------------------
 + Package installation:
   - px-lib-rw-guix-config : installed
   - px-setup-assistant    : installed
 + Running px-setup-assistant:
   - Add user as an argument
      * user (name:hamzeh, group:users, comment:no comment, Asia/Tehran, hostname:GUIXhamzeh, locale:en_US.utf8)
      * new-config.scm generated
      * guix reconfiguration done successfully
   - Done successfully
```

   