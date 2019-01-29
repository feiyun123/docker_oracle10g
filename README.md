# docker_oracle10g
docker安装oracle10g


步骤1：
准备好安装文件
pwd:/home/oracle
-rw-r--r--. 1 root root 801603584 Jan 17 16:33 10201_database_linux_x86_64.cpio
-rw-r--r--. 1 root root       949 Jan 17 18:37 enterprise.rsp
-rw-r--r--. 1 root root       124 Jan 18 12:45 install.sh
-rw-r--r--. 1 root root        71 Jan 18 09:48 limits.conf
-rw-r--r--. 1 root root        65 Jan 17 19:38 oraInst.loc
-rw-r--r--. 1 root root       641 Jan 18 12:44 profile
-rw-r--r--. 1 root root      1896 Jan 18 09:51 setup.sh
-rw-r--r--. 1 root root      1294 Jan 18 09:19 sysctl.conf


步骤2：
准备好Dockerfile
pwd:/home
-rw-r--r--. 1 root root     523 Jan 17 16:54 Dockerfile


步骤3：
使用dockerfile生成基础镜像
命令如下：
[root@localhost home]# docker build -t centos6-oracle10g:1.2 .

生成需要一段时间
打印如下信息后完成
Removing intermediate container c8df8f6091d6
 ---> 6585c0224fc6
Successfully built 6585c0224fc6
Successfully tagged centos6-oracle10g:1.2



步骤4：
运行生成的镜像
命令如下：
docker run -it --privileged -p 1521:1521 --name orcl centos6-oracle10g:1.2 /bin/bash

步骤5：
复制enterprise.rsp到/home/oracle进行修改
命令如下：
cp /home/oracle/database/response/enterprise.rsp /home/oracle/
vi /home/oracle/enterprise.rsp

修改的内容参考/home/oracle/enterprise.rsp



步骤6：
安排oracle
命令如下：
/home/oracle/install.sh

完成安装打印如下：

Installation in progress (Fri Jan 18 07:39:12 UTC 2019)
...............................................................  14% Done.
...............................................................  28% Done.
...............................................................  42% Done.
...............................................................  56% Done.
...............................................................  70% Done.
................                                                 74% Done.
Install successful

Linking in progress (Fri Jan 18 07:40:28 UTC 2019)
.                                                                74% Done.
Link successful

Setup in progress (Fri Jan 18 07:44:41 UTC 2019)
..................                                              100% Done.
Setup successful

End of install phases.(Fri Jan 18 07:44:45 UTC 2019)
WARNING:The following configuration scripts
/u01/app/oracle/product/10.2.0/db_1/root.sh
need to be executed as root for configuring the system. If you skip the execution of the configuration tools, the configuration will not be complete and the product wont function properly. In order to get the product to function properly, you will be required to execute the scripts and the configuration tools after exiting the OUI.

The installation of Oracle Database 10g was successful.
Please check '/u01/app/oracle/oraInventory/logs/silentInstall2019-01-18_07-38-58AM.log' for more details.

步骤7：
执行配置脚本，注意是使用root用户执行
命令如下：
[root@d04d09214dab oracle]# sh /u01/app/oracle/product/10.2.0/db_1/root.sh

打印如下：
Running Oracle10 root.sh script...

The following environment variables are set as:
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /u01/app/oracle/product/10.2.0/db_1

Enter the full pathname of the local bin directory: [/usr/local/bin]: /usr/local/bin
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...


Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root.sh script.
Now product-specific root actions will be performed.



步骤8：
使用DBCA静默建库

命令如下：
[oracle@d04d09214dab templates]$ pwd
/u01/app/oracle/product/10.2.0/db_1/assistants/dbca/templates
[oracle@d04d09214dab templates]$ dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbname orcl -sid orcl -sysPassword orclbsth -systemPassword orclbsth -responseFile NO_VALUE -datafileDestination /u01/app/oracle/oradata/ -recoveryAreaDestination /u01/app/oracle/flash_recovery_area -storageType FS -characterSet ZHS16GBK -nationalCharacterSet AL16UTF16 -sampleSchema true -memoryPercentage 30 -databaseType OLTP -emConfiguration NONE

步骤9：
启动oracle数据库和监听

1. linux下启动oracle 
su - oracle 
sqlplus /nolog 
conn /as sysdba 
startup 
exit 
lsnrctl start 
exit 






