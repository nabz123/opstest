#!/bin/bash
echo $1


if [[ ! -f $1 || -z $1 ]];
then
        echo "Error: Incorect Argument"
        exit 1
fi

echo "Loading...... $1"
makeUsers(){
        IFS=";"
        file=$1
        i=0

        while read col1 col2 col3 col4
        do
                ((i++))
        if [[ $i > 1 ]]
        then
                Fname=$(echo "$col1" | awk -F '@' '{print $1}' )
                Fname=$(echo "$Fname" | awk -F '.' '{print $1}')
                Fname=${Fname::1}

                Lname=$(echo "$col1" | awk -F '.' '{print $2}')
                Lname=$(echo "$Lname" | awk -F '@' '{print $1}' )

                Name="$Fname$Lname"
                echo "$Name"
                p1=$(echo "$col2" | awk -F '/' '{print $1}')
                p2=$(echo "$col2" | awk -F '/' '{print $2}')
                p3=$p2$p1

                echo "$p3"
                group=$(echo "$col3" | awk -F ',' '{print $2}')
                g=$(echo "$col3" | awk -F ',' '{print $1}')

                echo "$group"
                Folder=$(echo "$col4")

                echo "$Folder"

        if ! [[ -z "$group" ]]
        then
                     cat /etc/group | grep $group
                if [[ $? > 0 ]]
                then
                         groupadd $group
                else
                        echo "Group Already Exists"
                fi
        fi
         find /home$Folder > /dev/null 2>&1
        if ! [[ $? -eq 0 ]]
        then
         mkdir /home$Folder
         chmod 760 /home$Folder
        if [[ $? -eq 0 ]]
        then
                echo "Made /home$Folder"
        fi
         chown root:$group /home$Folder
         if [[ $? -eq 0 ]]
        then
                echo "$group owns $Folder"
        fi

        else
                echo "$group  $Folder exists"
        fi

        if [[ -z "$group" ]]
        then
        useradd -m -d /home/$Name -s /bin/bash  $Name
                if [[ $? = 0 ]]
                then
                echo "Created user $Name"

                else
                echo "$Name Exists"

                fi

        else  useradd -m -d /home/$Name -s /bin/bash  $Name -G $g,$group
        fi
                 echo "$Name:$p3" | sudo chpasswd
                if [[ $? -eq 0 ]]
                then
                echo "Changed password"
                fi



        ln -s /home$Folder /home/$Name/shared
         if [[ $? -eq 0 ]]
        then
                echo "Made link in /home$Folder to /home/$Name/shared"
        else
        echo "link exists"
        fi



        passwd -e $Name
        echo "password set to  expire"







fi










        done < $file
}
makeUsers $1

