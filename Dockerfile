FROM debian:bookworm
WORKDIR /

ENV PATH="$PATH:/tools"

RUN apt update
RUN apt install -y procps file
RUN apt install -y git curl wget libnewt-dev libssl-dev libncurses5-dev libsqlite3-dev build-essential libjansson-dev
RUN apt install -y libxml2-dev uuid-dev libedit-dev mpg123 ffmpeg subversion uuid-runtime

# Base
RUN useradd --system asterisk

ADD asterisk.Makefile /Makefile
RUN make
RUN make clean

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN devpackages=`dpkg -l|grep '\-dev'|awk '{print $2}'|xargs` \ 
  && DEBIAN_FRONTEND=noninteractive apt-get --yes purge --auto-remove autoconf build-essential git subversion bzip2 \
  cpp m4 make patch perl perl-modules pkg-config xz-utils ${devpackages}

CMD ["/entrypoint.sh"]
