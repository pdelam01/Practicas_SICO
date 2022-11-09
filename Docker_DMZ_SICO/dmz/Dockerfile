FROM ubuntu:20.04
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y openssh-server net-tools iputils-ping traceroute nano iproute2 iptables pkg-config nmap tcpdump apache2 wget curl libpam-google-authenticator rsyslog fail2ban
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
COPY ./sshd_config /etc/ssh/
RUN mkdir /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chmod 640 /root/.ssh/authorized_keys
COPY ./banner /etc/ssh/
COPY ./sshd /etc/pam.d/
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
COPY ./start.sh .
RUN chmod +x start.sh
# HTTPS Config
COPY ./index.html /var/www/html/
RUN mkdir /etc/apache2/certs
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/apache2/certs/apache-certificate.crt -keyout /etc/apache2/certs/apache.key -subj "/C=ES/ST=CYL/L=Leon/O=ULE/CN=pdelam01"
COPY ./000-default.conf /etc/apache2/sites-available/
# Solucionar el error: invalid command 'SSlEngine'
RUN a2enmod ssl
RUN service apache2 restart
# Fail2ban
COPY ./jail.conf /etc/fail2ban/
# Creamos usuario no root sin contraseña
RUN useradd -m -d /home/usuario -s /bin/bash user1
RUN echo 'user1:user1' |chpasswd
CMD ["./start.sh"]
