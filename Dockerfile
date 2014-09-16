
FROM darinmorrison/haskell:latest

MAINTAINER t10471 <t104711202@gmail.com>

ENV OPTS_APT -y --force-yes --no-install-recommends

RUN apt-get update\
 && apt-get install ${OPTS_APT}\
      zlib1g-dev \
      git \
      build-essential \
      wget \
      liblua5.2-dev \
      lua5.2 \
      libncurses5-dev \
##      UI系?
##      libgnome2-dev \
##      libgnomeui-dev \
##      libgtk2.0-dev \
##      libatk1.0-dev \
##      libbonoboui2-dev \
##      libcairo2-dev \
##      libx11-dev \
##      libxpm-dev \
##      libxt-dev \
      python-dev \
##      python3-dev \
##      ruby-dev \
      mercurial \
      checkinstall

RUN apt-get remove ${OPTS_APT}\
      vim \
      vim-runtime \
      gvim \
      vim-tiny \
      vim-common \
      vim-gui-common

RUN hg clone https://code.google.com/p/vim/ /root/vim
WORKDIR /root/vim
RUN ./configure --with-features=huge \
            --disable-darwin \
            --disable-selinux \
            --enable-luainterp \
##            --enable-perlinterp \
##            --enable-pythoninterp \
##            --enable-python3interp \
##            --enable-tclinterp \
##            --enable-rubyinterp \
##           C言語?
##            --enable-cscope \
##         日本語入力に必要らしい   
            --enable-multibyte \
            --enable-xim \
            --enable-fontset\
            --enable-gui=no
##            --enable-gui=gnome2
RUN make
RUN checkinstall \
            --type=debian \
            --install=yes \
            --pkgname="vim" \
            --maintainer="ubuntu-devel-discuss@lists.ubuntu.com" \
            --nodoc \
            --default


RUN echo "Host github.com\n\
  User git\n\
  Port 22\n\
  Hostname github.com\n\
  IdentityFile ~/.ssh/id_rsa_github\n\
  TCPKeepAlive yes\n\
  IdentitiesOnly yes\n" >> /root/.ssh/config

RUN echo "function share_history {\n\
    history -a\n\
    history -c\n\
    history -r\n\
}\n\
PROMPT_COMMAND='share_history'\n\
shopt -u histappend\n\
export HISTSIZE=9999\n" >> /root/.bashrc

ADD dotfiles.sh /root/

