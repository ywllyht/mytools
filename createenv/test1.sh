#!/bin/bash
# scripts to prepare dev env

function before_install {
  echo "You must run this script with bash not sh!"
  mkdir ~/myproject 2>/dev/null
  mkdir ~/Downloads 2>/dev/null
  return 0
  
}

function install_anaconda {
  echo "install anaconda"
  if [ -e ~/anaconda3 ]; then
     echo "anaconda3 exists, skip"
     return 0
  fi
  mkdir ~/Downloads
  wget -nc -P ~/Downloads https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh
  bash ~/Downloads/Anaconda3-5.2.0-Linux-x86_64.sh

  echo "upgrade pip"
  pip install --upgrade pip
  return 0
}

function install_git {
  git --version
  if [ $? -eq 0 ]; then 
      echo "git is installed, skip"
      return 0
  fi
  if [ -e /etc/redhat-release ]; then
     yum install -y git
  fi
     apt install -y git
  fi
  return 0
}

function download_mytools {
  cd ~/myproject
  git clone https://github.com/ywllyht/mytools.git

}


command_sequence=(
   before_install 
   install_git
   install_python
   download_mytools
)

for (( index=0; index<${#command_sequence[*]}; index++)); do
    echo ""
    echo "==============="
    echo "Executing ${index}th command '${command_sequence[$index]}'" 
    eval ${command_sequence[$index]}
    err=$?
    if [ $err -ne 0 ]; then
      echo "Command '${command_sequence[$index]}' failed with error $err " 
      #break
    else
      echo "Command '${command_sequence[$index]}' completed" 
    fi
done

