#!/bin/bash -e
# ----------------------------------------------------------------------------
#
# Package       : noggit
# Version       : noggit-0.8
# Source repo   : https://github.com/yonik/noggit
# Tested on     : UBI 9.3
# Language      : Java
# Travis-Check  : True
# Script License: Apache License, Version 2 or later
# Maintainer    : Mayur Bhosure <Mayur.Bhosure2@ibm.com>
#
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
set -e
PACKAGE_NAME=noggit
PACKAGE_URL=https://github.com/yonik/noggit.git
PACKAGE_VERSION=${1:-noggit-0.8}

# install tools and dependent packages
yum install -y java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless git wget
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# install maven
wget https://archive.apache.org/dist/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz
tar -zxf apache-maven-3.8.7-bin.tar.gz
cp -R apache-maven-3.8.7 /usr/local
ln -sf /usr/local/apache-maven-3.8.7/bin/mvn /usr/bin/mvn

# Cloning the repository
git clone $PACKAGE_URL
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION

# Define the old and new values for source and target
old_source=1.5
new_source=1.8
old_target=1.5
new_target=1.8

# Use sed to replace the old source and target values in pom.xml
sed -i "s/<source>$old_source<\/source>/<source>$new_source<\/source>/g" pom.xml
sed -i "s/<target>$old_target<\/target>/<target>$new_target<\/target>/g" pom.xml



#Build
if ! mvn -B clean install -fae ; then
    echo "------------------$PACKAGE_NAME:Install_fails-------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_Fails"
    exit 1
fi

#Test
if ! mvn test -DforkCount=2 ; then
    echo "------------------$PACKAGE_NAME:Install_success_but_test_fails---------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_success_but_test_Fails"
    exit 2
else
    echo "------------------$PACKAGE_NAME:Install_&_test_both_success-------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub  | Pass |  Both_Install_and_Test_Success"
    exit 0
fi
