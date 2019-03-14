FROM centos

RUN yum -y install epel-release
RUN yum -y update && yum -y install gcc \
  gcc-c++ \
  glibc-devel \
  make \
  ncurses-devel \
  openssl-devel \
  autoconf \
  java-1.8.0-openjdk-devel \
  wxBase.x86_64 \
  unixODBC \
  wxGTK \
  wxGTK-gl \
  mesa-libGLU \
  wget \
  git

RUN wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_21.3.1-1~centos~7_amd64.rpm && \
  rpm -Uvh esl-erlang_21.3.1-1~centos~7_amd64.rpm && \
  rm -f esl-erlang_21.3.1-1~centos~7_amd64.rpm


RUN git clone https://github.com/elixir-lang/elixir.git
RUN export PATH=$PATH:/elixir/bin
ENV LC_ALL=en_US.UTF-8
RUN locale

WORKDIR /elixir
RUN ls
RUN make clean && make test

CMD ["iex"]
