FROM centos

MAINTAINER Matsumoto Hiroko <h.matsumoto@sint.co.jp>

RUN yum -y install initscripts MAKEDEV

RUN yum check

RUN yum -y update

RUN yum -y install openssh-server

# 空パスワードの場合は以下をコメントアウト
# RUN sed -ri 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN /etc/init.d/sshd start

# 空パスワードの場合は以下をコメントアウト
# RUN passwd -d root

# 任意のパスワードの場合は以下をコメントアウト & パスワードを書き換える
# RUN echo 'root:root' | chpasswd

EXPOSE 22

CMD /sbin/init