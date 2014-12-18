#!/bin/sh
REMOTE_HOST=yuanpeng01@cq01-rdqa-pool121.cq01.baidu.com
REMOTE_DIR=/home/users/yuanpeng01

INSTALL_DIR=~/install

cd ~/software

#退出后再执行
#install jumbo and subversion
#cd
#bash -c "$( curl http://jumbo.baidu.com/install_jumbo.sh )"; source ~/.bashrc
#jumbo install subversion


#svn 
mkdir -p ~/ypwork
cd ~/ypwork
svn co --username yuanpeng01 --password $(cat ~/software/password) https://svn.baidu.com/ps/se/trunk/fe/i18n 

mkdir -p ~/zh-CN
cd ~/zh-CN
svn co --username yuanpeng01 --password $(cat ~/software/password) https://svn.baidu.com/ps/se/trunk/fe/tpl/www 
svn co --username yuanpeng01 --password $(cat ~/software/password) https://svn.baidu.com/ps/se/trunk/fe/tpl/result

#install fis

mkdir ~/fis
cd ~/fis
cp ~/software/start.sh .
. start.sh
cd -

tar zxf xhprof-0.9.2.tgz
cd xhprof-0.9.2/extension
$INSTALL_DIR/php/bin/phpize
./configure --with-php-config=~/fis/php-linux/bin/php-config
make
make install
cd -

sed -i '1i extension_dir="\/home\/search\/install\/php\/lib\/php\/extensions\/no-debug-non-zts-20060613\/"' ~/fis/php-linux/lib/php.ini

echo "[xhprof]" >> ~/fis/php-linux/lib/php.ini
echo "extension=xhprof.so" >> ~/fis/php-linux/lib/php.ini
echo "xhprof.output_dir=/tmp/" >> ~/fis/php-linux/lib/php.ini

cd -



##add evn.sh
#
#
#
##建立信任关系
#cd ~/.ssh
#ssh-keygen -t rsa
#echo "一直回车"
#ssh-agent bash
#ssh-add id_rsa
#scp id_rsa.pub ${REMOTE_HOST}:${REMOTE_DIR}/.ssh/id_rsa_search.pub
#ssh ${REMOTE_HOST} "cd ${REMOTE_DIR}/.ssh;touch authorized_keys;cat id_rsa_search.pub >> authorized_keys;chmod g-w authorized_keys;rm id_rsa_search.pub;"
