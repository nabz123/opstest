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
			
			pass1=$(echo "$col2" | awk -F '/' '{print $1}')
			pass2=$(echo "$col2" | awk -F '/' '{print $2}')
			pass3=$pass2$p1
 
			g1=$(echo "$col3" | awk -F ',' '{print $2}')
			g2=$(echo "$col3" | awk -F ',' '{print $1}')
 
			Directory=$(echo "$col4")

        if ! [[ -z "$g1" ]]
        then
			cat /etc/g1 | grep $g1
			if [[ $? > 0 ]]
			then
					groupadd $g1
			else
					echo "Group already exists"
			fi
        fi
         find /home$Directory > /dev/null 2>&1
        if ! [[ $? -eq 0 ]]
        then
        mkdir /home$Directory
        chmod 760 /home$Directory
        if [[ $? -eq 0 ]]
        then
			echo "Made /home$Directory"
        fi
         chown root:$g1 /home$Directory
         if [[ $? -eq 0 ]]
        then
			echo "$g1 owns $Directory"
        fi

        else
			echo "$g1  $Directory already exists"
        fi

        if [[ -z "$g1" ]]
        then
        useradd -m -d /home$User -s /bin/bash  $User
			if [[ $? = 0 ]]
			then
			echo "$User has been created"

			else
			echo "$Name alraedy exists"

			fi

        else  useradd -m -d /home$User -s /bin/bash  $User -G $g2,$g1
        fi
			echo "$User:$p3" | sudo chpasswd
			if [[ $? -eq 0 ]]
			then
			echo "Password has been changed"
			fi

        ln -s /home$Directory /home$User/shared
         if [[ $? -eq 0 ]]
        then
                echo "Created link in /home$Directory in /home$User/shared"
        else
        echo "link already exists"
        fi

        passwd -e $User
        echo "password is set to expire"

fi

        done < $file
}
makeUsers $1

