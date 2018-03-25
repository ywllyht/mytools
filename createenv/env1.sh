#!/bin/bash
# scripts to prepare dev env

function before_install {
  echo "You must run this script with bash not sh!"
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

  echo "upgrade pip"
  pip install --upgrade pip
  return 0
}

function install_cheat {
  cheat -v
  if [ $? -eq 0 ]; then
     echo "cheat is installed, skip"
     return 1
  fi
  pip install  cheat
  echo "export CHEAT_EDITOR=vi" >> ~/.bashrc
  echo "export DEFAULT_CHEAT_DIR='~/myproject/mytools/cheat'" >> ~/.bashrc
  return 0
  
}

function install_thefuck {
  fuck -v
  if [ $? -eq 0 ]; then
      echo "thefuck is installed, skip"
      return 1
  fi
  pip install  thefuck
  echo "eval $(thefuck --alias)" >> ~/.bashrc
  return 0
 
}

function install_autojump {
  autojump -v 
  if [ $? -eq 0 ]; then
      echo "autojump is installed, skip"
      return 1
  fi
  sudo apt-get install -y autojump
  echo "source /usr/share/autojump/autojump.sh" >> ~/.bashrc

}

function install_tmux {
  tmux -V 
  if [ $? -eq 0 ]; then
      echo "tmux is installed, skip"
      return 1
  fi
  sudo apt-get install -y tmux
  echo "set-window-option -g mouse on" >> ~/.tmux.conf

}

function other_configure {
  echo "install macro for ky huice engine"
  echo "eval \"$(_KY_COMPLETE=source ky)\"" >> ~/.bashrc
}

function install_tushare {
  echo "install tushare"
  pip install tushare
}

function install_talib {
  mkdir ~/Downloads 2>/dev/null
  cd ~/Downloads
  wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
  tar xzvf ta-lib-0.4.0-src.tar.gz
  cd ta-lib
  ./configure
  make
  sudo make install
  pip install ta-lib

  echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc   # add this line in ~/.bashrc, fix could find "libta_lib.so.0" issue

}

command_sequence=(
   before_install 
   install_python
   install_cheat
   install_thefuck
   install_autojump
   install_tmux
   install_tushare
   install_talib
   other_configure

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

