# -----------------------------------------------------------------------------
#
# Package       : popmotion
# Version       : v8.7.1
# Source repo   : https://github.com/Popmotion/popmotion
# Tested on     : RHEL 8.3
# Script License: Apache License, Version 2 or later
# Maintainer    : sachin.kakatkar@ibm.com
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

PACKAGE_NAME=popmotion
PACKAGE_VERSION=v8.7.1
PACKAGE_URL=https://github.com/Popmotion/popmotion.git
dnf install git -y
dnf install npm -y
mkdir test
cd test
git clone https://github.com/Popmotion/popmotion.git
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION
npm install --global yarn
yarn
yarn bootstrap
cd packages/popmotion
yarn test

