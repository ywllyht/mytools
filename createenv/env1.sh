#!/bin/bash
# scripts to prepare dev env

function before_install {
  echo "You must run this script with bash not sh!"
  if [ ! -d ~/myproject ]; then
      echo "mkdir ~/myproject"
      mkdir ~/myproject
  fi
  if [ ! -d ~/myproject ]; then
      echo "mkdir ~/Downloads"
      mkdir ~/Downloads
  fi
  return 0
  
}

function install_anaconda {
  echo "install anaconda"
  if [ -d ~/anaconda3 ]; then
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
     sudo yum install -y git
  else
     sudo apt install -y git
  fi
  return 0
}

function download_mytools {
  if [ -d ~/myproject/mytools ]; then
     echo "mytools exists, skip"
     return 0
  fi
  cd ~/myproject
  git clone https://github.com/ywllyht/mytools.git

}

function install_cheat {
  echo "you must run download_mytools first"
  cheat -v
  if [ $? -eq 0 ]; then
     echo "cheat is installed, skip"
     return 0
  fi
  pip install cheat
  echo "export CHEAT_EDITOR=vi" >> ~/.bashrc
  echo "export DEFAULT_CHEAT_DIR='~/myproject/mytools/cheat'" >> ~/.bashrc
  return 0
  
}

function install_thefuck {
  fuck -v
  if [ $? -eq 0 ]; then
      echo "thefuck is installed, skip"
      return 0
  fi
  pip install thefuck
  echo "eval $(thefuck --alias)" >> ~/.bashrc
  return 0
 
}

function install_autojump {
  autojump -v 
  if [ $? -eq 0 ]; then
      echo "autojump is installed, skip"
      return 0
  fi
  if [ -e /etc/redhat-release ]; then
     sudo yum install -y autojump
     echo "source /etc/profile.d/autojump.sh" >> ~/.bashrc
  else
     sudo apt install -y autojump
     echo "source /usr/share/autojump/autojump.sh" >> ~/.bashrc
  fi
  return 0

}


function install_tmux {
  tmux -V 
  if [ $? -eq 0 ]; then
      echo "tmux is installed, skip"
      return 0
  fi
  if [ -e /etc/redhat-release ]; then
     sudo yum install -y tmux
  else
     sudo apt install -y tmux
  fi
  
cat <<'EOF'>~/.tmux.conf

set-window-option -g mouse on

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

set -g @plugin 'tmux-plugins/tmux-resurrect'
# tmux-resurrect
set -g @resurrect-save-bash-history 'on'
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-strategy-vim 'session'
# set -g @resurrect-save 'S'
# set -g @resurrect-restore 'R'
# to keep window's name after we reload from resurrect
set-option -g allow-rename off

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF

  

}

function create_ssh_folder {
  if [ -d ~/.ssh ]; then
     echo ".ssh folder exist, skip"
     return 0
  fi
  mkdir ~/.ssh
  chmod 755 ~/.ssh

  echo "please copy id_rsa id_rsa.pub from somewhere, and chmod 644"

}


command_sequence=(
   before_install 
   install_git
   install_anaconda
   download_mytools
   install_cheat
   install_thefuck
   install_autojump
   install_tmux
   create_ssh_folder
)

for (( index=0; index<${#command_sequence[*]}; index++)); do
    echo ""
    
    echo "Executing ${index}th command '${command_sequence[$index]}'" 
    eval ${command_sequence[$index]}
    err=$?
    if [ $err -ne 0 ]; then
      echo "Command '${command_sequence[$index]}' failed with error $err " 
      #break
    else
      echo "Command '${command_sequence[$index]}' completed" 
    fi
    echo "================================"
done

echo ""

