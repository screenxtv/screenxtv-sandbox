#!/bin/sh

# If required commands are not executable, set this 0.
IS_SCREENX_EXECUTABLE=0

REPO_NAME="screenxtv-client" 
PREVIOUS_DIR=$PWD

# check if required commands installed.
function check_command {
  local COMMAND_NAME="$1"
  $COMMAND_NAME --version > /dev/null 2>&1
  COMMAND_STATUS=$?
  
  # check if the given command is correctly invoked.  
  # NOTE: `screen -v` returns 1 if successful, not 0.
  if [ $COMMAND_STATUS -gt 1 ]; then
      echo "\t$1 is ...\tNOT found."
      IS_SCREENX_EXECUTABLE=1
      return 127
  else
      echo "\t$1 is ...\tfound."
      return 0
  fi
}

echo "* checking required commands ..."
check_command "git"
check_command "g++"
check_command "screen"
#check_command "foobar" # dummy command for debug
echo ""

# stop installation if not executable.
if [ $IS_SCREENX_EXECUTABLE -gt 0 ]; then
    echo "Please install required commands.\n"
    exit
fi


if [ -s /tmp/$REPO_NAME ]; then
    echo "* already downloaded $REPO_NAME."
else
    echo "* downloading ScreenX TV Client ..."
    git clone https://github.com/tompng/$REPO_NAME.git --local /tmp/$REPO_NAME
fi
echo ""

# compile ScreenX TV Client
g++ -o /tmp/$REPO_NAME/run /tmp/$REPO_NAME/main.cc -lpthread -lutil
if [ $? -gt 0 ]; then
    echo "* can't run ScreenX TV Client. Please check errors above."
    exit
fi

# run ScreenX TV Client
cd /tmp/$REPO_NAME
echo "* going to start broadcasting ... \n"
/tmp/$REPO_NAME/run
