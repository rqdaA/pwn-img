FROM ubuntu:22.04
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN apt update && apt upgrade -y && \
    apt install -y git neovim python3 python3-pip python3-venv sudo curl wget unzip tmux make gcc netcat qemu-user qemu-system
RUN id ubuntu && userdel ubuntu || true
RUN groupadd user -g 1000 && useradd -m user -s /bin/bash -u 1000 -g 1000 -G sudo
RUN echo user:pwn | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo FLAG{REDUCTED} | tee /flag | tee /flag.txt
RUN wget -q https://raw.githubusercontent.com/bata24/gef/dev/install.sh -O- | sh

USER user
WORKDIR /home/user
RUN python3 -m venv .venv
RUN git config --global user.email "info@rqda.wtf" && git config --global user.name "rona" && \
    git clone https://github.com/radareorg/radare2.git && \
    git clone https://github.com/pwndbg/pwndbg && \
    git clone https://github.com/rqdaA/lysithea.git
RUN radare2/sys/install.sh
RUN cd lysithea/ && ./install.sh
RUN .venv/bin/pip install pwntools ptrlib
RUN cd pwndbg/ && ./setup.sh
RUN r2pm -U && r2pm -ci r2ghidra
RUN curl -L https://foundry.paradigm.xyz | bash && /home/user/.foundry/bin/foundryup
RUN mkdir ctf
RUN touch .sudo_as_admin_successful

USER root
COPY --chown=user .bashrc .
COPY --chown=user .gdbinit .
COPY --chown=user .tmux.conf .
COPY --chown=user init.vim /home/user/.config/nvim/
