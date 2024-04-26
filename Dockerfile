FROM ubuntu:22.04
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN apt update && apt upgrade -y 
RUN apt install -y git neovim python3 python3-pip python3-venv sudo curl wget unzip tmux make gcc qemu-system-x86-64
RUN id ubuntu && userdel ubuntu || true
RUN groupadd user -g 1001 && useradd -m user -s /bin/bash -u 1000 -g 1001 -G sudo
RUN echo user:pwn | chpasswd
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo FLAG{REDUCTED} | tee /flag | tee /flag.txt
USER user
WORKDIR /home/user

RUN python3 -m venv .venv
RUN git config --global user.email "info@rqda.wtf" && git config --global user.name "rona"
RUN git clone https://github.com/radareorg/radare2.git
RUN git clone https://github.com/pwndbg/pwndbg
RUN git clone https://github.com/rqdaA/lysithea.git
RUN git clone https://github.com/matrix1001/glibc-all-in-one.git
RUN radare2/sys/install.sh
RUN cd lysithea/ && ./install.sh
RUN .venv/bin/pip install pwntools && .venv/bin/pip install ptrlib
RUN bash -c "$(wget https://gef.blah.cat/sh -O -)"
RUN cd pwndbg/ && ./setup.sh
RUN r2pm -U && r2pm -ci r2ghidra
RUN curl -L https://foundry.paradigm.xyz | bash && /home/user/.foundry/bin/foundryup

USER root
RUN wget -q https://raw.githubusercontent.com/bata24/gef/dev/install.sh -O- | sh
COPY --chown=user .bashrc .
COPY --chown=user .gdbinit .
COPY --chown=user .tmux.conf .

USER user

RUN touch .sudo_as_admin_successful
RUN mkdir ctf
