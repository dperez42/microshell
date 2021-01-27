#!/bin/bash

test_my_line () {
	printf "\e[1;34m Probando: \e[0m"
	echo -n $@
	#echo $@ >> results/res1
	echo $(./microshell $@ )>> results/res1 &
	sleep .250
	echo >> results/res1
}
	#leaks microshell > leaks.res 2> /dev/null
	#if grep "ROOT LEAK" < leaks.res > /dev/null 2> /dev/null ; then
	#printf "\e[0;31mLEAKS\n\e[0m"
	#fi
	printf "\e[0;31m"
	##pid=$( pgrep microshell )
	#lsof -c microshell | grep $pid | grep -v cwd | grep -v txt | grep -v 0r | grep -v 1w | grep -v 2u | grep microshel
	#printf "\e[0m"
	#kill -9 $pid
	#wait $pid 2>/dev/null
	#cat -e out.res > out


test_line () {
	#echo $@
	echo $@ >> results/res2
	#$@ >> results/res2 &
	sleep .250
	echo >> results/res2
}

comp_results(){
	if diff results/res1 results/res2 > /dev/null 2>&1
	#if cmp -s out.res out1.res
	then
  		printf "\e[1;32m Ok\n\e[0m"
	else
  		printf "\e[1;31m Error\n\e[0m"
		  echo "----------- MY MINI ----------"
		  cat -e results/res1
		  echo "----------- BASH ----------"
		  cat -e results/res2
		  echo
	fi
	rm -f results/res1  results/res2 lresults/leaks.res results/out
}

printf "\e[1;32mCompile\n"
gcc -g -Wall -Werror -Wextra -DTEST_SH microshell.c -o microshell
printf "\e[1;36mTest\n\e[0m"
mkdir results
rm -f results/res1  results/res2 lresults/eaks.res results/out

test_my_line /bin/ls
test_line $(/bin/ls)
comp_results

test_my_line /bin/ls ";" /bin/ls
test_line $(/bin/ls ; ls)
comp_results

test_my_line /bin/cat microshell.c
test_line $(/bin/cat microshell.c)
comp_results

test_my_line /bin/ls microshell.c
test_line $(/bin/ls microshell.c)
comp_results

test_my_line /bin/ls microshell.c ";" /bin/ls
test_line $(/bin/ls microshell.c ; /bin/ls)
comp_results

test_my_line /bin/ls salut
test_line $(/bin/ls salut)
comp_results

test_my_line ";"
test_line $(;);
comp_results

test_my_line ";" ";"
est_line $(;;)
comp_results


test_my_line ";" ";" /bin/echo OK
test_line $(;;/bin/echo OK)
comp_results

#test_line ";" ";" /bin/echo OK ";"
#test_line ";" ";" /bin/echo OK ";" ";"
#test_line ";" ";" /bin/echo OK ";" ";" ";" /bin/echo OK

test_my_line /bin/ls "|" /usr/bin/grep microshell
test_line $(/bin/ls | /usr/bin/grep microshell)
comp_results

test_my_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro
test_line $(/bin/ls | /usr/bin/grep microshell | /usr/bin/grep micro)
comp_results

#test_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell

#test_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro

test_my_line /bin/ls ewqew "|" /usr/bin/grep micro "|" /bin/cat -n ";" /bin/echo dernier ";" /bin/echo
test_line $(/bin/ls ewqew | /usr/bin/grep micro | /bin/cat -n ; /bin/echo dernier ; /bin/echo)
comp_results

test_my_line /bin/ls "|" /usr/bin/grep micro "|" /bin/cat -n ";" /bin/echo dernier ";" /bin/echo ftest ";"
test_line $(/bin/ls | /usr/bin/grep micro | /bin/cat -n ; /bin/echo dernier ; /bin/echo ftest ;)
comp_results

#test_line /bin/echo ftest ";" /bin/echo ftewerwerwerst ";" /bin/echo werwerwer ";" /bin/echo qweqweqweqew ";" /bin/echo qwewqeqrtregrfyukui ";"

#test_line /bin/ls ftest ";" /bin/ls ";" /bin/ls werwer ";" /bin/ls microshell.c ";" /bin/ls subject.fr.txt ";"

#test_line /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";"

#test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b ";" /bin/cat subject.fr.txt ";"

#test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep w ";" /bin/cat subject.fr.txt ";"

#test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep w ";" /bin/cat subject.fr.txt

#test_line /bin/cat subject.fr.txt ";" /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b "|" /usr/bin/grep z ";" /bin/cat subject.fr.txt

#test_line ";" /bin/cat subject.fr.txt ";" /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b "|" /usr/bin/grep z ";" /bin/cat subject.fr.txt

test_my_line blah "|" /bin/echo OK
test_line $(blah | /bin/echo OK)
comp_results

test_my_line blah "|" /bin/echo OK ";"
test_line $(blah | /bin/echo OK ;)
comp_results

printf "\e[1;32mDone\e[0m\n"
rm -rf microshell.dSYM leaks.res