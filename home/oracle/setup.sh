set -e

#source /assets/colorechoi
trap "echo_red '******* ERROR: Something went wrong.'; exit 1" SIGTERM
trap "echo_red '******* Caught SIGINT signal. Stopping...'; exit 2" SIGINT

#Install prerequisites directly without virtual package
deps () {

      yum -y install binutils compat-libstdc++-33 compat-libstdc++-33.i686 elfutils-libelf elfutils-libelf-devel gcc gcc-c++ glibc glibc.i686 glibc-common glibc-devel glibc-devel.i686 glibc-headers ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel make sysstat libXp libXt.i686 libXtst.i686
}

# useradd new users for oracle install
users () {

      echo "Configuring users"
      groupadd -g 1000 oinstall
      groupadd -g 1001 dba
      useradd -u 1000 -g oinstall -G dba oracle
      echo "oracle:oracle" | chpasswd
      echo "root:root@123" | chpasswd
}

#makeup new folder for oracle data
folder(){
      echo "mkdir new folder for oracle data"

      mkdir -p /u01/app/oracle
      mkdir -p /u01/app/oracle/product/10.2.0/db_1
      mkdir -p /u01/app/oracle/admin/orcl/{a,b,c,d,u}dump
      mkdir -p /u01/app/oracle/oradata/orcl
      mkdir -p /u01/app/oracle/flash_recovery_area

}

# cp the release file
cp_file(){

      echo "cp the release file"
      cp /assets/10201_database_linux_x86_64.cpio /home/oracle
      cat /assets/profile > home/oracle/.bash_profile
      cp /assets/install.sh /home/oracle
      cp /assets/oraInst.loc /etc/
      cp /assets/enterprise.rsp /home/oracle/
      cp /assets/sysctl.conf /etc/sysctl.conf
      cat /assets/limits.conf >> /etc/security/limits.conf

}

#replace the owner
ower(){
      echo "replace the owner"
      chown -R oracle:oinstall /u01
      chown -R oracle:oinstall /home/oracle
      chown oracle:oinstall /etc/oraInst.loc
      chmod 664 /etc/oraInst.loc
      chmod 777 /tmp
}

deps
users
folder
cp_file
ower
