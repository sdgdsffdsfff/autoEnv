#!/bin/sh
REMOTE_HOST=yuanpeng01@cq01-rdqa-pool121.cq01.baidu.com
REMOTE_DIR=/home/users/yuanpeng01

INSTALL_DIR=~/install
mkdir -p ~/install
mkdir -p ~/bin


cd ~/software
#install java
mkdir -p $INSTALL_DIR/java
mv jdk-6u45-linux-x64.bin $INSTALL_DIR/java

cd $INSTALL_DIR/java
chmod +x jdk-6u45-linux-x64.bin
./jdk-6u45-linux-x64.bin
rm jdk-6u45-linux-x64.bin
ln -s $INSTALL_DIR/java/jdk1.6.0_45/bin/java ~/bin/java
cd -

#install node
mkdir -p $INSTALL_DIR/node
mv node.tgz $INSTALL_DIR/node

cd $INSTALL_DIR/node
tar -xzvf node.tgz 
rm node.tgz

ln -s $INSTALL_DIR/node/bin/node ~/bin/node
ln -s $INSTALL_DIR/node/bin/npm ~/bin/npm
cd -

#install apache
tar -xzvf httpd-2.2.29.tar.gz
cd httpd-2.2.29
mkdir -p $INSTALL_DIR/apache
./configure --prefix=$INSTALL_DIR/apache --enable-module=so
make
make install
cd -


#install php
tar -xzvf php-5.2.17.tar.gz
cd php-5.2.17
./configure --prefix=$INSTALL_DIR/php --with-config-file-path=$INSTALL_DIR/php/etc
make
make install

./configure --prefix=$INSTALL_DIR/php --with-apxs2=$INSTALL_DIR/apache/bin/apxs
make
make install

cp php.ini-dist $INSTALL_DIR/php/etc/php.ini

#add config to httpd.conf
sed -i '/conf\/mime\.types/a\
      AddType application\/x-httpd-php \.php \.phtml \.php3 \.inc\
      AddType application\/x-httpd-php-source \.phps
' $INSTALL_DIR/apache/conf/httpd.conf

sed -i 's/Listen\s*80/Listen 8900/' $INSTALL_DIR/apache/conf/httpd.conf

#modify php.ini
sed -i 's/register_globals\s*=\s*Off/register_globals = On/' $INSTALL_DIR/php/etc/php.ini
cd -

#install xhprof
tar zxf xhprof-0.9.2.tgz
cd xhprof-0.9.2/extension
$INSTALL_DIR/php/bin/phpize
./configure --with-php-config=$INSTALL_DIR/php/bin/php-config
make
make install
cd -

cd xhprof-0.9.2
cp -r xhprof_html xhprof_lib $INSTALL_DIR/apache/htdocs/

sed -i 's/extension_dir\s*=/#extension_dir =/' $INSTALL_DIR/php/etc/php.ini
sed -i '/extension_dir\s*=/a\
extension_dir="\/home\/search\/install\/php\/lib\/php\/extensions\/no-debug-non-zts-20060613\/"
' $INSTALL_DIR/php/etc/php.ini

echo "[xhprof]" >> $INSTALL_DIR/php/etc/php.ini
echo "extension=xhprof.so" >> $INSTALL_DIR/php/etc/php.ini
echo "xhprof.output_dir=/tmp/" >> $INSTALL_DIR/php/etc/php.ini

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
rm -rf ~/.vim/*
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

#vimrc
tar xzf vimrc.tgz
mkdir -p ~/.vim
cp -r .vim/* ~/.vim/
cp -r .vimrc ~/

#install command-T
#cd ~/.vim/
#vim command-t-1.11.4.vba 
#:so %
#cd ~/.vim/ruby/command-t 
#ruby extconf.rb 
#make 
#cd -

#modify ~/.bashrc
cat bash_config >> ~/.bashrc

#退出后再执行
#install fis

#mkdir ~/fis
#cd ~/fis
#cp ~/software/start.sh .
#. start.sh
#cd -

#install jumbo and subversion
#cd
#bash -c "$( curl http://jumbo.baidu.com/install_jumbo.sh )"; source ~/.bashrc
#jumbo install subversion


#svn 
#mkdir -p ~/ypwork
#cd ~/ypwork
#svn co --username yuanpeng01 https://svn.baidu.com/ps/se/trunk/fe/i18n 
##add evn.sh
#
#
##modify .bashrc
#
##建立信任关系
#cd ~/.ssh
#ssh-keygen -t rsa
#echo "一直回车"
#ssh-agent bash
#ssh-add id_rsa
#scp id_rsa.pub ${REMOTE_HOST}:${REMOTE_DIR}/.ssh/id_rsa_search.pub
#ssh ${REMOTE_HOST} "cd ${REMOTE_DIR}/.ssh;touch authorized_keys;cat id_rsa_search.pub >> authorized_keys;chmod g-w authorized_keys;rm id_rsa_search.pub;"
