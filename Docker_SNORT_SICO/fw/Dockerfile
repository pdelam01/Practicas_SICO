FROM ubuntu:20.04
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config nmap tcpdump wget

# Descarga y configuración de Snort
#RUN git clone https://github.com/snort3/libdaq.git
#cd libdaq
#./bootstrap
#./configure
#make
#make install


# RUN wget https://github.com/snort3/snort3/archive/refs/tags/3.1.28.0.tar.gz && \
#    tar xzf 3.1.28.0.tar.gz && \
#    cd snort3-3.1.28.0 && \
#    ./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc

RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
COPY ./start.sh .
RUN chmod +x start.sh

# IP Tables Script
COPY ./iptables.sh .
RUN chmod +x iptables.sh
CMD ["./start.sh"]