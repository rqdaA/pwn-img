FROM ubuntu:23.10
RUN apt update && apt upgrade -y && apt install -y git neovim python3 python3-pip python3-venv sudo curl wget unzip tmux make gcc
RUN userdel ubuntu
RUN groupadd user -g 1001 && useradd -m user -s /bin/bash -u 1000 -g 1001 -G sudo
RUN echo user:pwn | chpasswd
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER user
WORKDIR /home/user

RUN python3 -m venv .venv
RUN .venv/bin/pip install pwntools
RUN git clone https://github.com/radareorg/radare2.git 
RUN git clone https://github.com/pwndbg/pwndbg
RUN radare2/sys/install.sh && r2pm -U && r2pm -ci r2ghidra
RUN cd pwndbg/ && ./setup.sh
RUN bash -c "$(wget https://gef.blah.cat/sh -O -)"

RUN touch .sudo_as_admin_successful
COPY .bashrc .
COPY .gdbinit .
COPY .tmux.conf .

RUN mkdir ctf
