FROM debian:jessie
MAINTAINER Jan-Erik Revsbech <janerik@moc.net>

RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir /var/run/sshd
RUN mkdir -p /var/run/sshd /var/log/supervisor

#Copy ssh keys
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
COPY files/authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

#Copy supervisor files
COPY files/supervisord.conf /etc/supervisor/supervisord.conf
COPY files/sshd.conf /etc/supervisor/conf.d/sshd.conf

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]
