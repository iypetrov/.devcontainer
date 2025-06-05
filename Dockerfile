FROM ubuntu:25.10
ENV DEBIAN_FRONTEND=noninteractive

# Secrets
ARG ANSIBLE_VAULT_PASSWORD
RUN echo "${ANSIBLE_VAULT_PASSWORD}" > /tmp/ansible-vault-pass.txt

# Dependencies
RUN apt update
RUN apt install -y curl 
RUN apt install -y wget 
RUN apt install -y git 
RUN apt install -y vim 
RUN apt install -y tmux 
RUN apt install -y zsh 
RUN apt install -y htop 
RUN apt install -y fzf 
RUN apt install -y unzip 
RUN apt install -y build-essential 
RUN apt install -y ripgrep 
RUN apt install -y ca-certificates 
RUN apt install -y openssh-client 
RUN apt install -y sudo 
RUN apt install -y make 
RUN apt install -y stow
RUN apt install -y software-properties-common
RUN apt install -y lazygit
RUN apt install -y ansible
RUN rm -rf /var/lib/apt/lists/*

# Repositories
RUN mkdir -p /projects/common
RUN mkdir -p /projects/personal
RUN mkdir -p /projects/work

## common
RUN git clone https://github.com/iypetrov/vault.git /projects/common/vault

RUN find /projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN find /projects/common/vault/.aws -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN rm -rf /home/root/.ssh
RUN ln -sfn /projects/common/vault/.ssh /home/root
RUN ln -sfn /projects/common/vault/.aws /home/root

RUN git clone https://github.com/iypetrov/.dotfiles.git /projects/common/.dotfiles
RUN cd /projects/common
RUN stow --target=/home/root .dotfiles
RUN cd /home/root

RUN git clone git@github.com:iypetrov/books.git /projects/common/books

# Teardown
RUN rm /tmp/ansible-vault-pass.txt

WORKDIR /root
