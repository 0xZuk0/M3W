#!/bin/bash
#
#
#

printf "Host Name : %s\n" `uname -n`
printf "Kernel Release : %s\n" `uname -r`
printf "Kernel Version : $s\n" `uname -v`
printf "Architecture : %s\n" `uname -m`
printf "Operating System : %s\n" `uname -o`

temp1=$(ping -c 2 google.com)

if [ $? -eq 0 ]
then
    printf "Internet : Available\n"
else
    printf "Internet : Not Available\n"
fi

ips=( $(ip a | sed -n '/inet [0-9]*/p' | cut -d ' ' -f 6 | cut -d '/' -f 1) )
interface=( $(ip a | sed -n '/inet [0-9]*/p' | awk '{ print $NF }') )
printf "\n"
printf "INTERFACE AND RELATED IPS\n"
printf "\n"
printf "Interface\tIP\n"
printf "\n"
for ((i=0;i<${#ips[@]};i++))
do
    printf "%s\t\t%s\n" "${interface[i]}" "${ips[i]}"
done

printf "\nCURRENT USER INFO\n"
printf "\n%s\n\n" "`id`"

setuid_files=( $(find / -perm -4000 2> /dev/null) )

upper_border="[+]------------------------------------------------------------[+]\n"
lower_border="[+]------------------------------------------------------------[+]\n\n"

printf $upper_border
printf " |\t\t\tSETUID PERMISSIONS FILE\t\t\t| \n"
printf $lower_border

for file in ${setuid_files[@]}
do
    printf "[~] %s\n" $file
done

system_users=( $(cat /etc/passwd | cut -d ':' -f 1) )
shells=( $(cat /etc/passwd | cut -d ':' -f 7) )

bash_shell="/bin/bash"
simple_shell="/bin/sh"

printf "\n"
printf $upper_border
printf " |\t\tUSERS WITH BASH OR SH SHELL\t\t\t| \n"
printf $lower_border

for ((i=0;i<${#shells[@]};i++))
do
    if [ "${shells[i]}" = "$bash_shell" -o "${shells[i]}" = "$simple_shell" ]
    then
        printf "[-] %s\t\t%s\n" "${system_users[i]}" "${shells[i]}"
    fi
done


