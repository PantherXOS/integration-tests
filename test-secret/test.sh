#!/bin/sh
echo "-------------------------------------------------"
echo "             px-secret-service test"
echo "-------------------------------------------------"

add_params()
{
./test-secret addParam wallet1 app1 param1 value1
if [ $? != 0 ];then 
	exit 1
fi
./test-secret addParam wallet1 app2 param2 value2
if [ $? != 0 ];then 
        exit 1
fi
./test-secret addParam wallet2 app3 param3 value3
if [ $? != 0 ];then 
        exit 1
fi
./test-secret addParam wallet3 app4 param4 value4 
if [ $? != 0 ];then 
        exit 1
fi
exit 0
}

if [ "$1" = "add_params" ]; then
	add_params
fi
