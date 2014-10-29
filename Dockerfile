## haskell-base 
FROM t10471/base:latest

MAINTAINER t10471 <t104711202@gmail.com>

ENV OPTS_APT -y --force-yes --no-install-recommends

RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      ctags \
      libghc-pcre-light-dev \
      libpcrecpp0 \
      libpcre3-dev

ADD init.sh /root/
