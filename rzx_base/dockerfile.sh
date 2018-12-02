#!/bin/bash

INSTALL_DIR=/opt/install

JDK_VER=jdk1.8.0_181
JDK_ARCH_NAME=jdk-8u181-linux-x64.tar.gz
JDK_ORACLE_DOWNLOAD_LINK=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/$JDK_ARCH_NAME

ANT_VER=apache-ant-1.10.5
ANT_ARCH_NAME=$ANT_VER-bin.zip
ANT_APACHE_DOWNLOAD_LINK=http://ftp.byfly.by/pub/apache.org//ant/binaries

GROOVY_VER=groovy-2.5.2
GROOVY_ARCH_NAME=apache-groovy-binary-2.5.2.zip
GROOVY_APACHE_DOWNLOAD_LINK=http://ftp.byfly.by/pub/apache.org/groovy/2.5.2/distribution

GRADLE_VER=gradle-4.10
GRADLE_ARCH_NAME=$GRADLE_VER-bin.zip
GRADLE_DOWNLOAD_LINK=https://services.gradle.org/distributions

SCRIPTS_PATH=/opt/scripts
IMAGE_SCRIPT=rzx_base.sh
STARTUP_SCRIPT=startup.sh

mkdir $SCRIPTS_PATH

function zypper_install_from_txt() {

    zypper -n up
    zypper -n --gpg-auto-import-keys ref
    
    while read -r line
    do
	    zypper -n --no-gpg-checks in -y -f $line
    done < $1 

}

# base.txt contains names of software 
zypper_install_from_txt $INSTALL_DIR/base.txt

# install fish shell
chsh -s /usr/bin/fish

FISH_CONFIG=/root/.config/fish/config.fish

mkdir /root/.config/
mkdir /root/.config/fish

echo "set -g -x LANG ru_RU.UTF-8" >> $FISH_CONFIG
echo "set -g -x PATH /usr/local/bin \$PATH" >> $FISH_CONFIG
echo "set -g -x PATH /opt/scripts \$PATH" >> $FISH_CONFIG
echo "set -g -x JAVA_HOME /opt/java8/$JDK_VER" >> $FISH_CONFIG
echo "set -g -x PATH /opt/java8/$JDK_VER/bin \$PATH" >> $FISH_CONFIG
echo "set -g -x GRADLE_HOME /opt/bt/gradle/$GRADLE_VER" >> $FISH_CONFIG
echo "set -g -x PATH /opt/bt/gradle/$GRADLE_VER/bin \$PATH" >> $FISH_CONFIG
echo "set -g -x GROOVY_HOME /opt/bt/groovy/$GROOVY_VER" >> $FISH_CONFIG
echo "set -g -x PATH /opt/bt/groovy/$GROOVY_VER/bin \$PATH" >> $FISH_CONFIG
echo "set -g -x ANT_HOME /opt/bt/ant/$ANT_VER" >> $FISH_CONFIG
echo "set -g -x PATH /opt/bt/ant/$ANT_VER/bin \$PATH" >> $FISH_CONFIG
echo "alias python='python3'" >> $FISH_CONFIG
echo "alias ll='ls -ls'" >> $FISH_CONFIG
echo "if test -e /root/ip" >> $FISH_CONFIG
echo "    set line (head -n 1 /root/ip)" >> $FISH_CONFIG
echo "    set -g -x IP \$line" >> $FISH_CONFIG
echo "end" >> $FISH_CONFIG

ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime

mkdir /opt/java8
wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_ORACLE_DOWNLOAD_LINK -P /tmp
tar -xzf /tmp/$JDK_ARCH_NAME -C /opt/java8

mkdir /opt/bt
mkdir /opt/bt/ant
mkdir /opt/bt/groovy
mkdir /opt/bt/gradle

wget $ANT_APACHE_DOWNLOAD_LINK/$ANT_ARCH_NAME -P /tmp
unzip /tmp/$ANT_ARCH_NAME -d /opt/bt/ant

wget $GROOVY_APACHE_DOWNLOAD_LINK/$GROOVY_ARCH_NAME -P /tmp
unzip /tmp/$GROOVY_ARCH_NAME -d /opt/bt/groovy

wget $GRADLE_DOWNLOAD_LINK/$GRADLE_ARCH_NAME -P /tmp
unzip /tmp/$GRADLE_ARCH_NAME -d /opt/bt/gradle

# sshd access settings: user: root; password: 123456
# ! CHANGE IT PLEASE !

ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
ssh-keygen -A -f /etc/ssh/ -N ''

echo -e "123456\n123456\n" | passwd

pip install --upgrade pip
pip install pytest && pip install psutil && pip install jsonpickle && pip install selenium && pip install pymysql && pip install cx_Oracle

# if docker run command contains IP enviroment variable, then set IP to file /root/ip
# see rzx_wildfly image

echo "#!/bin/bash" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "if [[ ! -z \$IP ]]; then" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "  if [ ! -f /root/ip ]; then" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "    echo \$IP > /root/ip" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "  fi" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "else" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "  echo '127.0.0.1' > /root/ip" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "fi" >> $SCRIPTS_PATH/$IMAGE_SCRIPT

echo "#!/bin/bash" >> $SCRIPTS_PATH/$STARTUP_SCRIPT
echo "$SCRIPTS_PATH/$IMAGE_SCRIPT &" >> $SCRIPTS_PATH/$STARTUP_SCRIPT

echo "#!/bin/bash" >> $SCRIPTS_PATH/entrypoint.sh
echo "$SCRIPTS_PATH/$STARTUP_SCRIPT" >> $SCRIPTS_PATH/entrypoint.sh
echo "/usr/sbin/sshd -D -e" >> $SCRIPTS_PATH/entrypoint.sh

rm -rf /tmp/*
rm -rf ${INSTALL_DIR}
chmod 777 -R /opt