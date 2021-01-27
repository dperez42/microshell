#!/bin/bash

test_line () {
	#echo "The parameters are: $@"
	#echo $@
	echo $@ >> res1 &
	#sleep .250
	#echo >> res1
}
rm res1
test_line $(/bin/ls | /usr/bin/grep testa)
cat res1
#rm res1
#(/bin/ls | /usr/bin/grep testa) >> res1