FROM eosio/builder

RUN apt-get update -y && \
    apt-get install -y tree patch vim screen openssh-server openssl ca-certificates psmisc && rm -rf /var/lib/apt/lists/*

# Install latest nodejs
RUN mkdir /nodejs && wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz && \
    tar xvJf node-v8.11.3-linux-x64.tar.xz -C /nodejs --strip-components=1 && rm -f node-v8.11.3-linux-x64.tar.xz

# Setup sshd
RUN mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
