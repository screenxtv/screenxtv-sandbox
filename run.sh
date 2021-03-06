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
      echo "  $1 is ... found."
      return 0
  else
      echo "  $1 is ... NOT found."
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

# stop broadcasting if not executable.
if [ $IS_SCREENX_EXECUTABLE -gt 0 ]; then
    echo "Please install the required commands above."
    echo ""
    exit
fi

# download latest code if not downloaded yet
if [ -s $TMP/$REPO_NAME ]; then
    echo "* already downloaded $REPO_NAME."
else
    echo "* downloading ScreenX TV Client ..."
    git clone https://github.com/screenxtv/$REPO_NAME.git --local $TMP/$REPO_NAME
fi
echo ""

# compile ScreenX TV Client
echo "* compile source"
make --directory=$TMP/$REPO_NAME
if [ $? -gt 0 ]; then
    echo "* can't run ScreenX TV Client. Please check errors above."
    echo ""
    exit
fi
echo ""

# create a config file to skip several steps (because this is just a sandbox).
CONFIG_PATH=$TMP/$REPO_NAME/screenxtv.conf
if [ -s $CONFIG_PATH ]; then
    echo "* config file was found."
else
    echo "* creating config file ..."
    echo "host: screenx.tv"         > $CONFIG_PATH
    echo "port: 8000"               >> $CONFIG_PATH
    echo "slug:"                    >> $CONFIG_PATH
    echo "url:"                     >> $CONFIG_PATH
    echo "screen: screenxtv"        >> $CONFIG_PATH 
    echo "color: black"             >> $CONFIG_PATH 
    echo "title: Anonymous Sandbox" >> $CONFIG_PATH 
fi
echo ""

# run ScreenX TV Client
echo "* going to start broadcasting ... "
$TMP/$REPO_NAME/$REPO_NAME -f $CONFIG_PATH < /dev/tty
echo ""
echo "* stopped broadcasting."
echo ""
echo "* To resume(attach) the broadcasting screen,"
echo "  re-type the command."
echo "    curl -s -L https://raw.github.com/screenxtv/screenxtv-sandbox/master/run.sh | bash"
echo ""
echo "* To delete the downloaded files,"
echo "  remove the following directory."
echo "    rm -rf $TMP/$REPO_NAME"
echo ""
echo "* To make the best use of ScreenX TV Client,"
echo "  please visit here, read instructions, and install it."
echo "    https://github.com/screenxtv/screenxtv-gcc-client"
echo ""
echo "  Thanks,"
echo "  ScreenX TV Team"
echo ""

