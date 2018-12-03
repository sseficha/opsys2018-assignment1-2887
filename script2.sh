

assignments=$(find . -name "assignments")
if [ -z $assignments ]; then
	mkdir assignments
	git init --quiet
fi
cd assignments
folder=$(find ~ -name "$1")
repos=$(find $folder -mindepth 1)		
for repo in $repos; do
	ext="${repo##*.}"		#extention has to be txt, else ignore
	if [ "$ext" != "txt" ]; then
		continue
	fi	
	URL=0
	line=1
	haserror=0
	while [ ! -z $URL ]; do
		URL=$(sed -n $line"p" < $repo)
		if [ ! -z $URL ]; then
			first=$(echo $URL | head -c 1)
			if [ "$first" = "#" ]; then
				line=$(($line+1))
			else
				first=$(echo $URL | cut -c1-5)

				if [ "$first" = "https" ]; then

					break
				else
					haserror=1
					break
				fi
			fi
		fi
	done
	if [ $haserror -eq 0 ]; then
		git clone --quiet $URL 2> /dev/null
		if [ $? -eq 0 ]; then
			echo "$URL: Cloning OK"
		else
			echo "$URL: Cloning Failed"
		fi
	else
		echo "$repo: Grammatical error"

	fi
done
echo
repos=$(find . -maxdepth 1 -mindepth 1 -not -path '*/\.*')	#repos cloned in assignments

for i in $repos
do
	dirs=0
	txts=0
	others=0
	struct=0
	files=$(find $i -mindepth 1 -not -path '*/\.*')
	i=$(echo $i | cut -c3-)
	for j in $files
	do
		if [ "$j" = "./$i/more" ] || [ "$j" = "./$i/dataA.txt" ] || [ "$j" = "./$i/more/dataB.txt" ] || \
		[ "$j" = "./$i/more/dataC.txt" ]; then
			struct=$(($struct+1))
		else
			struct=$(($struct-1))
		fi
		if [ -d $j ]; then
			dirs=$(($dirs+1))
			continue
		fi
		ext="${j##*.}"
		if [ "$ext" = "txt" ]; then	
			txts=$(($txts+1))
		else
			others=$(($others+1))
		fi	
	done
	echo "repo $i:"
	echo "Number of directories: $dirs"
	echo "Number of txt files: $txts"
	echo "Number of other files: $others"
	if [ $struct -eq 4 ]; then
		echo "Directory structure is OK"
	else
		echo "Directory structure is NOT OK"
	fi
	echo
	
done

