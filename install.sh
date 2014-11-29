#!/bin/sh
REMOTE_HOST=yuanpeng01@cq01-rdqa-pool121.cq01.baidu.com
REMOTE_DIR=/home/users/yuanpeng01

INSTALL_DIR=~/install
mkdir install
mkdir bin

#install fis
mkdir ~/fis
cd ~/fis
cp ~/software/start.sh .
. start.sh


cd ~/software

#install node
tar -xzvf node-v0.10.28.tar.gz 
cd node-v0.10.28
mkdir -p $INSTALL_DIR/node
./configure --prefix=$INSTALL_DIR/node
make
make install
ln -s $INSTALL_DIR/node/bin/node ~/bin/node
ln -s $INSTALL_DIR/node/bin/npm ~/bin/npm
cd -

#install ruby
tar -xzvf ruby-2.1.5.tar.gz 
cd ruby-2.1.5
mkdir -p $INSTALL_DIR/ruby
#absolute path!!
./configure --prefix=$INSTALL_DIR/ruby
make
make install
ln -s $INSTALL_DIR/ruby/bin/ruby ~/bin/ruby
cd -

#install vim
tar -xjf vim-7.4.tar.bz2
cd vim74
mkdir -p $INSTALL_DIR/vim
./configure --prefix=$INSTALL_DIR/vim/ --with-features=huge --enable-multibyte --enable-rubyinterp
make
make install
ln -s $INSTALL_DIR/vim/bin/vim ~/bin/vim
ln -s $INSTALL_DIR/vim/bin/vimtutor ~/bin/vimtutor
ln -s $INSTALL_DIR/vim/bin/vimdiff ~/bin/vimdiff
cd -

#install command-T
#cd ~/.vim/
#vim command-t-1.11.4.vba 
#:so %
#cd ~/.vim/ruby/command-t 
#ruby extconf.rb 
#make 
#cd -


#svn 
mkdir -p ~/ypwork/i18n
cd ~/ypwork/i18n

#add evn.sh


#modify .bashrc

#建立信任关系
cd ~/.ssh
ssh-keygen -t rsa
echo "一直回车"
ssh-agent bash
ssh-add id_rsa
scp id_rsa.pub ${REMOTE_HOST}:${REMOTE_DIR}/.ssh/id_rsa_search.pub
ssh ${REMOTE_HOST} "cd ${REMOTE_DIR}/.ssh;touch authorized_keys;cat id_rsa_search.pub >> authorized_keys;chmod g-w authorized_keys;rm id_rsa_search.pub;"
