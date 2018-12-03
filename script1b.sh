#i moni diafora me to 1o script einai stin seira 49
	
execute() {				
	if [ ! -z $URL ]
	then
		URL2=$(echo $URL | tr '/' '_')	#gia na min exo error otan apothikevo file me onoma link
		saved_site=$(find ./saved_sites2 -name $URL2)
		if [ ! -z $saved_site ]
		then
			wget -qO-  -O ./"temp_$URL2" $URL
			if [ $? != 0 ]; then echo "$URL FAILED"; rm "temp_$URL2"; return; fi
			new_site=$(find . -name "temp_$URL2")
			temp=$(diff $saved_site $new_site)
			if [  $? -ne 0 ]
			then
				echo $URL
				cat $new_site > $saved_site
			fi
			rm "temp_$URL2"
		else
			echo "$URL INIT"
			touch ./saved_sites2/$URL2
			wget -qO- -O ./saved_sites2/$URL2 $URL
			if [ $? != 0 ]; then echo "$URL FAILED"; rm "temp_$URL2"; return; fi 
			
		fi

	fi
}


folder=$(find . -name "saved_sites2")
if [ -z $folder ]
then
	mkdir saved_sites2
fi
i=1
URL=0
sites=$(find ~ -name $1)
while [ ! -z $URL ]; do
	URL=$(sed -n $i"p" < $sites)
	first=$(echo $URL | head -c 1)
	if [ "$first" = "#" ]
	then
		i=$(($i+1))
		URL=0
		continue
	fi
	execute &
	i=$(($i+1))
done




