#!/usr/bin/env bash

#replace_or_add_string <search_string> <replace_string> <filename>
function replace_or_add_string_in_file(){
    if grep -q "$1" $3; then
        if [[ $1 != "" && $2 != "" ]]; then
            echo replacing $1 with $2 in file $3
            sed -i "s/$1/$2/" $3
        fi
    else
        echo -e "\n$2" >> $3
    fi
}
function replace_string_in_file(){
    if grep -q "$1" $3; then
        if [[ $1 != "" && $2 != "" ]]; then
            echo replacing $1 with $2 in file $3
            sed -i "s/$1/$2/" $3
        fi
    fi
}

#add_string_in_file <string> <filename>
function add_string_in_file(){
    if grep -q "$1" $2; then
        echo "string $1 already in file $2"
    else 
        echo -e "\n$1" >> $2
    fi
}

#sudo_replace_or_add_string_in_file <search_string> <replace_string> <filename>
function sudo_replace_or_add_string_in_file(){
    if sudo grep -q "$1" $3; then
        if [[ $1 != "" && $2 != "" ]]; then
            echo replacing $1 with $2 in file $3
            sudo sed -i "s/$1/$2/" $3
        fi
    else
        sudo bash -c "echo -e "\n$2" >> $3"
    fi
}
function sudo_replace_string_in_file(){
    if sudo grep -q "$1" $3; then
        if [[ $1 != "" && $2 != "" ]]; then
            echo replacing $1 with $2 in file $3
            sudo sed -i "s/$1/$2/" $3
        fi
    fi
}

#sudo_add_string_in_file <string> <filename>
function sudo_add_string_in_file(){
    if grep -q "$1" $2; then
        echo "string $1 already in file $2"
    else 
        echo "adding string $1 in file $2"
        sudo bash -c "echo -e "" >> $2"
        sudo bash -c "echo -e ""$1"" >> $2"
    fi
}

#################################

function install_apt_package(){
    REQUIRED_PKG=$1
    PKG_OK=$(echo $(dpkg-query -W -f='${Status}' $REQUIRED_PKG 2>/dev/null | grep -c "ok installed"))
    #echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ $PKG_OK -eq 0 ]; then
        echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        sudo apt-get --yes install $REQUIRED_PKG
    else
        echo "$REQUIRED_PKG is already present."
    fi    
}
function install_apt_packages(){
    for pkg in "$@"
    do
        install_apt_package "$pkg"
    done
}

#################################

function get_after_last_slash(){
    ret=$(echo $1 | sed 's:.*/::')
    echo $ret 
}
function get_virtualenv_name(){
    cmd_out=$(printenv | grep VIRTUAL_ENV)
    virtual_env_name=$(get_after_last_slash $cmd_out)
    echo $virtual_env_name
}

function check_pip_package(){
    package_name=$1
    PKG_OK=$(pip3 list --format=legacy |grep $package_name)
    #echo "checking for $package_name: $PKG_OK"
    if [ "" == "$PKG_OK" ]; then
        #echo "$package_name is not installed"
        echo 1
    else
        #echo "$package_name is already installed"
        echo 0
    fi
}

function install_pip3_package(){
    do_install=$(check_pip_package $1)
    virtual_env=$(get_virtualenv_name)
    if [ $do_install -eq 1 ] ; then
        if [ "" == "$virtual_env" ]; then
            echo "installing pip3 package $package_name"
            pip3 install --user $1          
        else
            echo "installing pip3 package $package_name"
            pip3 install $1     # if you are in a virtual environment the option `--user` will make pip3 install things outside the env 
        fi
    else
        echo "pip3 package $1 is already installed"
    fi 
}
function install_pip3_packages(){
    for pkg in "$@"
    do
        install_pip3_package "$pkg"
    done
}

#################################

function print_blue(){
	printf "\033[34;1m"
	printf "$@ \n"
	printf "\033[0m"
}

function print_red(){
	printf "\033[31;1m"
	printf "$@ \n"
	printf "\033[0m"
}

#################################
function check_last_command_valid () {
    if [ $? -eq 0 ]; then
        echo 0
    else
        print_red "Last command failed!"
        echo 1
    fi
}