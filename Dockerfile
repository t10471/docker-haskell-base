## haskell-base 
FROM t10471/base:latest

MAINTAINER t10471 <t104711202@gmail.com>

ENV OPTS_APT -y --force-yes --no-install-recommends

## add ppa for ubuntu trusty haskell packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286\
 && echo 'deb     http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list\
 && echo 'deb-src http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' >> /etc/apt/sources.list.d/haskell.list

## install ghc dependencies
RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      gcc\
      libc6\
      libc6-dev\
      libgmp10\
      libgmp-dev\
      libncursesw5\
      libtinfo5\
      threadscope\
      libdevil-dev\
      libtaoframework-devil1.6-cil

## install llvm for the ghc backend
RUN apt-get update\
 && apt-get install ${OPTS_APT} llvm

RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      ctags \
      libghc-pcre-light-dev \
      libpcrecpp0 \
      libpcre3-dev

## haskell package versions; can be overriden via context hacks
ENV VERSION_ALEX   3.1.4
ENV VERSION_CABAL  1.22
ENV VERSION_HAPPY  1.19.5

## install minimal set of haskell packages
RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      alex-"${VERSION_ALEX}"\
      cabal-install-"${VERSION_CABAL}"\
      happy-"${VERSION_HAPPY}"

## haskell package versions; can be overriden via context hacks
ENV VERSION_GHC    7.10.2

## install ghc
RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      ghc-"${VERSION_GHC}"

## set the VERSION vars and PATH for login shells
RUN\
  ( exec >> /etc/profile.d/haskell.sh\
 && echo "VERSION_ALEX=${VERSION_ALEX}"\
 && echo "VERSION_CABAL=${VERSION_CABAL}"\
 && echo "VERSION_HAPPY=${VERSION_HAPPY}"\
 && echo "VERSION_GHC=${VERSION_GHC}"\
 && echo 'PATH=${HOME}/.cabal/bin:${PATH}'\
  )

## link the binaries into /usr/local/bin
RUN find /opt -maxdepth 3 -name bin -type d\
  -exec sh -c\
    'cd {} && ls .\
      | egrep -v ^.*\-[.[:digit:]]+$\
      | xargs -I % ln -s `pwd`/% /usr/local/bin/%' \;

ADD init.sh /root/
