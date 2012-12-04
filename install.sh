#!/bin/sh

# If required commands are not executable, set this 0.
IS_SCREENX_EXECUTABLE=0

REPO_NAME="screenxtv-gcc-client" 
PREVIOUS_DIR=$PWD
TMP=/tmp

# check if required commands installed.
function check_command {
  local COMMAND_NAME="$1"
  which $COMMAND_NAME > /dev/null 2>&1
  COMMAND_STATUS=$?
  
  # check if the given command is correctly invoked.  
  if [ $COMMAND_STATUS = 0 ]; then
      echo "\t$1 is ...\tfound."
      return 0
  else
      echo "\t$1 is ...\tNOT found."
      IS_SCREENX_EXECUTABLE=1
      return 127
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


if [ -s $TMP/$REPO_NAME ]; then
    echo "* already downloaded $REPO_NAME."
else
    echo "* downloading ScreenX TV Client ..."
    git clone https://github.com/tompng/$REPO_NAME.git --local $TMP/$REPO_NAME
fi
echo ""

# compile ScreenX TV Client
g++ -o $TMP/$REPO_NAME/run $TMP/$REPO_NAME/main.cc -lpthread -lutil
if [ $? -gt 0 ]; then
    echo "* can't run ScreenX TV Client. Please check errors above."
    exit
fi

# run ScreenX TV Client
echo "* going to start broadcasting ... \n"
cd $TMP/$REPO_NAME
$TMP/$REPO_NAME/run < /dev/tty
cd $PREVIOUS_DIR
echo "\n* stopped broadcasting.\n"
echo ""
echo "* If you'd like to resume(attach) the broadcasting screen again,"
echo "  just re-type the command."
echo "    curl -s -L https://raw.github.com/yasulab/screenxtv-sandbox/master/install.sh | sh"
echo ""
echo "* If you'd like to uninstall, remove the installed directory."
echo "    rm -rf $TPM/$REPO_NAME"
echo ""

