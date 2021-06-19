#!/bin/bash

ADDRESS=

ftpFile=client-side-instructions.sh
svInsFile=server-side-instructions.sh

while getopts "fi" name
do
        case $name in
          f)fopt=1;;
          i)iopt=1;;
          *)echo "Invalid arg"; echo "-f ftp"; echo "-i Upload and execute .sh";
        esac
done

if [[ ! -z $fopt ]]
then

  echo "";
  echo "- ftp"

  sftp -b ./$ftpFile $ADDRESS 

  echo "";

fi

if [[ ! -z $iopt ]]
then
  echo "";
  echo "- Upload and execute .sh"

  scp $svInsFile $ADDRESS:"~/dev/$svInsFile"
  ssh $ADDRESS "cd ~/dev/ && chmod +x $svInsFile && ./$svInsFile"

  echo "";

fi

