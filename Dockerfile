FROM ubuntu:16.04

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo wget curl net-tools ca-certificates unzip gnupg

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y git-core automake autoconf libtool build-essential pkg-config libtool \
     mpi-default-dev libicu-dev python-dev python3-dev libbz2-dev zlib1g-dev libssl-dev libgmp-dev \
     clang-4.0 lldb-4.0 lld-4.0 llvm-4.0-dev libclang-4.0-dev ninja-build

RUN update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-4.0/bin/clang 400 \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-4.0/bin/clang++ 400

RUN apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y tree patch vim screen openssh-server openssl ca-certificates psmisc \
  && rm -rf /var/lib/apt/lists/*

# Install latest nodejs
RUN mkdir /nodejs && wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz && \
    tar xvJf node-v8.11.3-linux-x64.tar.xz -C /nodejs --strip-components=1 && rm -f node-v8.11.3-linux-x64.tar.xz

# Setup sshd
RUN mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
