#!/bin/bash
# scripts to prepare dev env

function install_python2 {
  echo "make sure you have ran following commands"
  echo "  apt install -y git"
  echo "  mkdir ~/myprojects"
  echo "  mkdir ~/downloads"
  echo "  cd ~/myprojects; git clone https://github.com/ywllyht/mytools.git"
}

function install_python {
  echo "install anaconda"
  if [ -e ~/anaconda3 ]; then
     echo "anaconda3 exists, skip"
     return 1
  fi
  mkdir ~/Downloads
  wget -nc -P ~/Downloads https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
  bash ~/Downloads/Anaconda3-4.2.0-Linux-x86_64.sh

  return 0
}


command_sequence=(
   #before_install 
   install_python
   install_python2

)

for (( index=0; index<${#command_sequence[*]}; index++)); do
    echo "Executing ${index}th command '${command_sequence[$index]}'" 
    eval ${command_sequence[$index]}
    err=$?
    if [ $err -ne 0 ]; then
      echo "Command '${command_sequence[$index]}' failed with error $err " 
      #break
    else
      log_msg "Command '${command_sequence[$index]}' completed" 
    fi
done

