
FROM amazonlinux:latest
MAINTAINER Nuzul <nuzul.hafizi@mims.com>

ARG buildno
RUN echo "Build number: $buildno"

COPY package_list /usr/etc/
RUN yum install -y $(cat /usr/etc/package_list)
RUN yum update -y
RUN yum install -y vi
#RUN yum install -y git
RUN yum install -y java-1.8.0-openjdk

WORKDIR /var/www/html/
ADD ./config/httpd/conf/ /etc/httpd/conf/
ADD ./config/httpd/conf.d/ /etc/httpd/conf.d/
ADD ./config/httpd/conf.modules.d/ /etc/httpd/conf.modules.d/
ADD ./config/httpd/conf/ /etc/httpd/conf/
ADD ./config/etc/php.ini /etc/

#ADD ./config/id_rsa /root/.ssh/id_rsa
#ADD ./git/git_clone /var/www/html/
#RUN chmod -R 600 /root/.ssh/id_rsa
#RUN chmod 777 /var/www/html/git_clone
#ADD ./git/cis/ /var/www/html/
#ADD ./webserver/start.sh /var/www/html/
#CMD chmod 777 /var/www/html/start.sh


#Make ssh dir
#RUN mkdir /root/.ssh/;exit 0

#Copy over private key, and set permissions
#RUN cp id_rsa /root/.ssh/id_rsa

#Create known_hosts
#RUN touch /root/.ssh/known_hosts

#Add bitbuckets key
#RUN ssh-keyscan -T 60 bitbucket.org >> /root/.ssh/known_hosts

#Clone the conf files into the docker container
#RUN git clone git@bitbucket.org:mimscareer/cis.git
#CMD ./git_clone

#Create symlink
#RUN ln -s /var/www/html/cis prod
ADD ./config/html/.htaccess /var/www/html/
#ADD ./config/.htaccess /var/www/html/cis/

#Create www user
RUN useradd www
RUN usermod -aG wheel www
RUN chown -R www:www /var/www/html

#ENTRYPOINT /etc/init.d/httpd CMD start
#CMD ["/bin/bash", "/etc/init.d/httpd start"]
#CMD ["service" "httpd" "start"]
#CMD /etc/init.d/httpd start
#ENTRYPOINT ["/usr/sbin/httpd"] & CMD ["-D", "FOREGROUND"] 
#RUN service httpd start

#EXPOSE 22 80 443 4567

#VOLUME /data
#RUN touch /data/testfile

#RUN A2ENMOD REWRITE
#RUN DOCKER-PHP-EXT-INSTALL PDO PDO_MYSQL GD CURL

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
