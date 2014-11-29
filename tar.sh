#!/bin/sh
#打包文件，排除.git
tar czf auto.tgz * --exclude="*/.svn"

