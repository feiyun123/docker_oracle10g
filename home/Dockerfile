FROM centos:6

USER root
RUN mkdir /assets
COPY oracle /assets
RUN chmod -R 755 /assets && /assets/setup.sh

USER oracle
WORKDIR /home/oracle
ENV PATH=$PATH:$HOME/.local/bin:$HOME/bin:/home/oracle/.local/bin:/home/oracle/bin:/home/oracle/bin:/u01/app/oracle/product/10.2.0/db_1/bin  ORACLE_BASE=/u01/app/oracle ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1 ORACLE_SID=orcl LD_LIBRARY_PATH=/u01/app/oracle/product/10.2.0/db_1/lib:/lib:/usr/lib
RUN cpio -idmv < 10201_database_linux_x86_64.cpio

EXPOSE 1521
EXPOSE 8080
