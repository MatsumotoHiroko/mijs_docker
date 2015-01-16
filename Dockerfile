FROM centos

MAINTAINER Matsumoto Hiroko <h.matsumoto@sint.co.jp>

RUN yum update -y
RUN yum install -y httpd php php-mbstring # phpとapacheをinstall
RUN yum clean all
ADD ./site/ /var/www/html/ # ソースコードをコンテナ内へコピー
 
EXPOSE 80 # 80番ポートを紐付け
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"] # httpdプロセス起動