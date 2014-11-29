#!/usr/bin/env bash
####################################
# config
####################################
SERVER="http://10.48.30.87:8088/svn/fis/fis-new/"

####################################
# check env
####################################

allpass='0'
checkfunc(){
    
    which $1
    if [ "$?" = "1" ]; then
        echo "Can't find command {$1}"
        allpass='1'
    fi
}

checkfunc "autoconf"
checkfunc "make"
checkfunc "sed"

which java >/dev/null 2>&1
if [ $? -eq 0 ]
then
    VERSION=`java -version 2>&1 | grep version | awk '{print $3}' | sed 's/"//g' | awk -F . '{print $1$2}'`
    if [ $VERSION -lt 16 ]
    then
        echo "The JAVA version is too low, install the JAVA version 1.6 or later "
        allpass=1
    fi
else
    echo "the java env is not exist, please check!"
    allpass=1
fi

DownloadCommand="wget"
which wget >/dev/null 2>&1
if [ $? -ne 0 ]
then
    
    which curl >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
        echo "Can't find wget and curl, please check and try again"
        allpass=1
    else
        DownloadCommand="curl"
    fi
fi


if [ "$allpass" = "1" ]; then
    echo 'Please install these command then try again'
    exit 1
else
    echo 'Commond check complate!'
fi


####################################
# function
####################################
update(){
    _MNAME=$1
    _MDIR=$2
    echo "start update $_MNAME"
    _MPATH=$_MDIR
    _update=0
    if [ ! -f $_MPATH/version.txt ]
    then
        if [ ! -d "$_MPATH" ]
        then
            mkdir "$_MPATH"
        fi

        echo -n "download [$_MNAME/version.txt]......"
        if [ "$DownloadCommand" = "wget" ]; then
            wget -qO "$_MPATH/.version.txt" "$SERVER/$_MDIR/version.txt"
        else
            curl -s "$SERVER/$_MDIR/version.txt" > "$_MPATH/.version.txt"
        fi

        if [ $? -ne 0 ]
        then
            echo "error"
            exit 1
        else
            echo "ok"
        fi
        _update=1
    else
        if [ "$DownloadCommand" = "wget" ]; then
            _version_new=`wget -qO - "$SERVER/$_MDIR/version.txt"|head -n 1|sed 's/^ *//;s/ *$//'`
        else
            _version_new=`curl -s "$SERVER/$_MDIR/version.txt"|head -n 1|sed 's/^ *//;s/ *$//'`
        fi

        if [ $_version_new != `head -n 1 "$_MPATH/version.txt"|sed 's/^ *//;s/ *$//'` ]
        then
            echo -n "update [$_MNAME/version.txt]......"
            if [ "$DownloadCommand" = "wget" ]; then
                wget -qO "$_MPATH/.version.txt" "$SERVER/$_MDIR/version.txt"
            else
                curl -s "$SERVER/$_MDIR/version.txt" > "$_MPATH/.version.txt"
            fi

            if [ $? -ne 0 ]
            then
                echo "error"
                exit 1
            else
                echo "ok"
            fi
            _update=1
        fi
    fi
    if [ $_update -eq 1 ]
    then
        find $_MPATH/* ! -name ".version.txt" -delete >/dev/null 2>&1
        for _file in `sed '1d' $_MPATH/.version.txt`
        do
            _tmpdir=`dirname "$_MPATH/$_file"`
            if [ ! -d $_tmpdir ]
            then
                mkdir -p "$_tmpdir"
            fi
            echo -n "download [$_MPATH/$_file]......"
            if [ "$DownloadCommand" = "wget" ]; then
                wget -qO "$_MPATH/$_file" "$SERVER/$_MDIR/$_file"
            else
                curl -s "$SERVER/$_MDIR/$_file" > "$_MPATH/$_file"
            fi

            if [ $? -ne 0 ]
            then
                touch "$_MPATH/$_file"
            fi
            echo "ok"
        done
        mv -f "$_MPATH/.version.txt" "$_MPATH/version.txt"
    fi
    echo "update $_MNAME done!"
    return $_update
}

echo 'Checking server, timeout = 10s'
if [ "$DownloadCommand" = "wget" ]; then
    wget -O  /dev/null -q --tries=1 --timeout=10 "$SERVER"
else
    curl -s --connect-timeout 10 --retry 1 "$SERVER" > /dev/null
fi
if [ "$?" = "0" ]; then
    ####################################
    # init
    ####################################
    SERVER=`echo $SERVER |sed 's/\/*$//'`
    echo $SERVER
    IFS_OLD=$IFS
    IFS=$'\n'

    ####################################
    # update client
    ####################################
    update "client" "client"

     ####################################
    # update loader
    ####################################
    update "loader" "loader"

   ####################################
    # update loader
    ####################################
    update "bin" "bin"

    ####################################
    # update libs
    ####################################
    
    #TOOLSDIR="libs/imageTools"
    update "libs" "libs"

    #if [ $? -eq 1 ]
    #then
    #    SYS=`uname -s`
    #    if [ "$SYS" = "Darwin" ]; then
    #        echo "Darwin"
    #    else
    #        echo "strat build images tools"
    #        cd $TOOLSDIR/pngquant/
    #        /bin/bash build.sh
    #        if [ $? -eq 1 ]
    #        then
    #            exit 1
    #        fi
    #        cd ..
    #        cd ..
    #        cd ..
    #    fi
    #fi

    ####################################
    # update tools
    ####################################
    #update "tools" "tools"

    ####################################
    # update php
    ####################################
    PHPDIR="php-linux"
    update "php" $PHPDIR

    if [ $? -eq 1 ]
    then
        echo "start build php"
        cd $PHPDIR
        /bin/bash build.sh
        if [ $? -eq 1 ]
        then
            exit 1
        fi
        cd ..
    fi

fi

####################################
# start server
####################################
IFS=$IFS_OLD
if [ ! -f tmp ]
then
    mkdir -p tmp
fi
echo $$> tmp/server.pid

ls "client/FIS-Client.jar" > /dev/null 2>&1
if [ "$?" = "0" ]; then
    java -jar "client/FIS-Client.jar"
else 
    echo 'Connect ' $SERVER ' timeout!'
fi
