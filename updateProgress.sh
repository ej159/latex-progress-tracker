#!/bin/sh

# If you want to run this as a cron job, on OSX you need to add the following to your PATH
# Not on OSX, you'll need to find the corresponding directories
# export PATH=/usr/local/bin:/Library/TeX/texbin/:$PATH

echo "Updating progress"
TEX_PATH='/home/edwardjones/git/Thesis'
TEX_DOC=${TEX_PATH}'/main.tex'
DOCUMENT='/home/edwardjones/git/Thesis/main.pdf'
OUTPUTDIR='/home/edwardjones/git/latex-progress-tracker/latex-progress-tracker-data'
PROGRESSFILE=${OUTPUTDIR}'/progress.csv'
HERE=$(pwd)


cd $TEX_PATH
git pull 
cd $HERE


# Setup CSV if it doesn't exist
if [ ! -f ${PROGRESSFILE} ]; then
    echo "timestamp,wordcount,pagecount" >> ${PROGRESSFILE}
fi

WORDCOUNT=0

for f in ${TEX_PATH}/*.tex;
do echo "Processing $f file..";
	DOCCOUNT=`texcount -sum -total -merge $f | grep "Sum count:" | tr -d "Sum count:"`
	echo $f:$DOCCOUNT
	WORDCOUNT=$((WORDCOUNT+DOCCOUNT))
done

echo $WORDCOUNT

# Use this line in OSX
#PAGECOUNT=`mdls -name kMDItemNumberOfPages -raw ${DOCUMENT}`
# Use this line in Linux
PAGECOUNT=`pdfinfo ${DOCUMENT} | grep Pages | sed 's/[^0-9]*//'`

echo `date '+%Y-%m-%d %H:%M:%S'`,$WORDCOUNT,$PAGECOUNT >> $PROGRESSFILE
echo "Done! Page count ${PAGECOUNT}, word count ${WORDCOUNT}. Written to ${PROGRESSFILE}"

python plotProgress.py ${PROGRESSFILE}
cd $OUTPUTDIR
git add progress.csv
timestamp=$(date +"%F %T")
git commit -m "Autocommit $timestamp" 
git push 
cd ..
