FROM fedora

ADD https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basic-linuxx64.rpm /tmp/build/basic.rpm
ADD https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-sqlplus-linuxx64.rpm /tmp/build/sqlplus.rpm

RUN dnf install /tmp/build/*.rpm -y && \
    rm -rf /tmp/build/
