FROM registry.fedoraproject.org/fedora:latest

ADD https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basic-linuxx64.rpm /tmp/build/basic.rpm
ADD https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-sqlplus-linuxx64.rpm /tmp/build/sqlplus.rpm

RUN dnf install entr /tmp/build/*.rpm -y && \
    dnf autoremove -y && dnf clean all && \ rm -rf /tmp/build/
