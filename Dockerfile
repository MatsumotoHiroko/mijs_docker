FROM ubuntu:14.04

MAINTAINER Matsumoto Hiroko <h.matsumoto@sint.co.jp>

# Ubuntu update
ADD sources.list /etc/apt/sources.list
RUN apt-get -y update

# Hack for initctl not being available in Ubuntu
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# ssh install
RUN apt-get -y install openssh-server
RUN apt-get -y install python-setuptools
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor

# MySQL install
RUN apt-get install -y mysql-server
RUN apt-get clean

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

# sshd config
ADD id_rsa.pub /root/id_rsa.pub
RUN mkdir /root/.ssh/
RUN mv /root/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
RUN sed -i -e '/^UsePAM\s\+yes/d' /etc/ssh/sshd_config

# supervisor config
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

# MySQL config
ADD mysql-listen.cnf /etc/mysql/conf.d/mysql-listen.cnf
RUN (/usr/bin/mysqld_safe &); sleep 3; mysqladmin -u root password 'passw0rd'; (echo 'grant all privileges on *.* to root@"%" identified by "passw0rd" with grant option;' | mysql -u root -ppassw0rd)

# Define mountable directories.
VOLUME ["/var/lib/mysql"]

# Expose ports.
EXPOSE 22 3306

# Define default command.
CMD ["supervisord", "-n"]