#!/bin/sh

#Thanks https://gist.github.com/FireBurn/00bff4931a53e4380575707ac0f20fc8

BASE_DIR=`pwd`

HTTPD24_VERSION=2.4.58
HTTPD22_VERSION=2.2.34
APR_VERSION=1.6.5
APR_UTIL_VERSION=1.6.3

#clean

rm -rf apr-*
rm -rf httpd-*

# Download source files

wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/httpd/httpd-${HTTPD24_VERSION}.tar.bz2
wget https://archive.apache.org/dist/httpd/httpd-${HTTPD22_VERSION}.tar.bz2
wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/apr/apr-${APR_VERSION}.tar.bz2
wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/apr/apr-util-${APR_UTIL_VERSION}.tar.bz2

# Extract the code and move apr and apr-util into place

tar xvfj httpd-${HTTPD24_VERSION}.tar.bz2
tar xvfj httpd-${HTTPD22_VERSION}.tar.bz2
tar xvfj apr-${APR_VERSION}.tar.bz2 -C httpd-${HTTPD24_VERSION}/srclib/
tar xvfj apr-${APR_VERSION}.tar.bz2 -C httpd-${HTTPD22_VERSION}/srclib/
tar xvfj apr-util-${APR_UTIL_VERSION}.tar.bz2 -C httpd-${HTTPD24_VERSION}/srclib/
tar xvfj apr-util-${APR_UTIL_VERSION}.tar.bz2 -C httpd-${HTTPD22_VERSION}/srclib/

mv httpd-${HTTPD24_VERSION}/srclib/apr-${APR_VERSION}/ httpd-${HTTPD24_VERSION}/srclib/apr/
mv httpd-${HTTPD22_VERSION}/srclib/apr-${APR_VERSION}/ httpd-${HTTPD22_VERSION}/srclib/apr/
mv httpd-${HTTPD24_VERSION}/srclib/apr-util-${APR_UTIL_VERSION}/ httpd-${HTTPD24_VERSION}/srclib/apr-util/
mv httpd-${HTTPD22_VERSION}/srclib/apr-util-${APR_UTIL_VERSION}/ httpd-${HTTPD22_VERSION}/srclib/apr-util/

# Configure HTTPD with APR and APR Util

echo "configure apache24----------------------------"
cd ${BASE_DIR}/httpd-${HTTPD24_VERSION}
./configure --with-included-apr

echo "configure apache24 ---------------------------"
cd ${BASE_DIR}/httpd-${HTTPD22_VERSION}
./configure --with-included-apr 

cd ${BASE_DIR}

# These fix up the includes with our new apache and apr builds
sed -i 's#Iextlib/$(OS_ARCH)_$(OS_MARCH)/apache24/include#I'"${BASE_DIR}"'/httpd-'"${HTTPD24_VERSION}"'/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD24_VERSION}"'/srclib/apr/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD24_VERSION}"'/srclib/apr-util/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD24_VERSION}"'/os/unix#g' Makefile
sed -i 's#Iextlib/$(OS_ARCH)_$(OS_MARCH)/apache22/include#I'"${BASE_DIR}"'/httpd-'"${HTTPD22_VERSION}"'/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD22_VERSION}"'/srclib/apr/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD22_VERSION}"'/srclib/apr-util/include $(COMPILEFLAG)I'"${BASE_DIR}"'/httpd-'"${HTTPD22_VERSION}"'/os/unix#g' Makefile
