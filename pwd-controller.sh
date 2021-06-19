#!/bin/bash


while getopts "a:su:i:d:" name
do
        case $name in
          a)ADDRESS=$OPTARG;;
          s)sopt=1;;
          u)uopt+=("$OPTARG");;
          i)iopt+="$OPTARG";;
          d)dopt+=("$OPTARG");;
          *)echo "Invalid arg";  echo "-a [arg] Address"; echo "-s Setup Server"; echo "-u [arg] Upload file"; echo "-i [arg] Upload and execute .sh"; echo "-d [arg] Download file";
        esac
done

if [[ ! -z $sopt ]]
then
  echo "";
  echo "- Setup Server"

  ssh $ADDRESS "mkdir ~/dev"
  echo "";

fi

if [[ ! -z $uopt ]]
then
  echo "";
  echo "- Upload"

  for val in "${uopt[@]}"; do
      echo " - Uploading $val"
      dir="$(dirname -- $val)"
      if [ "$dir" == "." ]; then
        scp $val $ADDRESS:"~/dev/$val"
      else
        ssh $ADDRESS "mkdir -p ~/dev/$dir"
        scp $val $ADDRESS:"~/dev/$val"
      fi
  done

  echo "";

fi

if [[ ! -z $iopt ]]
then
  echo "";
  echo "- Upload and execute .sh"

  for val in "${iopt[@]}"; do
      echo " - Uploading $val"
      dir="$(dirname -- $val)"
      if [ "$dir" == "." ]; then
        scp $val $ADDRESS:"~/dev/$val"
        ssh $ADDRESS "cd ~/dev/ && chmod +x $val && ./$val"
      else
        ssh $ADDRESS "mkdir -p ~/dev/$dir"
        scp $val $ADDRESS:"~/dev/$val"
        ssh $ADDRESS "cd ~/dev/ && chmod +x $val && ./$val"
      fi
  done

  echo "";

fi


if [[ ! -z $dopt ]]
then
  echo "";
  echo "- Download"


  for val in "${dopt[@]}"; do
      echo " - $val"
      dir="$(dirname -- $val)"
      mkdir -p "./downloads"
      if [ "$dir" == "." ]; then
        scp $ADDRESS:"~/dev/$val" "./downloads/$val"
      else
        mkdir -p "./downloads/$dir"
        scp $ADDRESS:"~/dev/$val" "./downloads/$val"
      fi
  done

  echo "";

fi