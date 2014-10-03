#!/bin/bash

OUT_DIR=/opt
APP_DIR=~/apps
DL_DIR=~/Downloads

mkdir -p $OUT_DIR
mkdir -p $APP_DIR

wget "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/R/eclipse-java-luna-R-linux-gtk-x86_64.tar.gz&r=1" -O $DL_DIR/eclipse.tar.gz
tar -xvzf $DL_DIR/eclipse.tar.gz -C $APP_DIR

wget http://ftp.unicamp.br/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz -P $DL_DIR
sudo tar --no-same-owner -xvzf $DL_DIR/apache-maven-3.2.3-bin.tar.gz -C $OUT_DIR
sudo ln -sf $OUT_DIR/apache-maven-3.2.3 $OUT_DIR/maven

wget http://ftp.unicamp.br/pub/apache/ant/binaries/apache-ant-1.9.4-bin.tar.gz -P $DL_DIR
sudo tar --no-same-owner -xvzf $DL_DIR/apache-ant-1.9.4-bin.tar.gz -C $OUT_DIR
sudo ln -sf $OUT_DIR/apache-ant-1.9.4 $OUT_DIR/ant

wget https://dl.google.com/android/adt/adt-bundle-linux-x86_64-20140702.zip -P $DL_DIR
unzip $DL_DIR/adt-bundle-linux-x86_64-20140702.zip -d $APP_DIR
ln -s $APP_DIR/adt-bundle-linux-x86_64-20140702 $APP_DIR/android

cat << EOF
Download and configure java in $OUT_DIR
EOF

