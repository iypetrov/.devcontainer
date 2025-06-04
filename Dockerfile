FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

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
RUN git clone https://github.com/iypetrov/vault.git /projects/common/vault
RUN ln -sfn /projects/common/vault /projects/common
RUN ansible-vault decrypt --ask-vault-pass /projects/common/vault/ansible-vault-pass.txt
RUN find /projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /projects/common/vault/ansible-vault-pass.txt {} \;
RUN find /projects/common/vault/auth_codes -type f -exec ansible-vault decrypt --vault-password-file /projects/common/vault/ansible-vault-pass.txt {} \;
RUN rm -rf /home/root/.ssh
RUN ln -sfn /projects/common/vault/.ssh /home/root
RUN ln -sfn /projects/common/vault/auth_codes /home/root
RUN git clone https://github.com/iypetrov/.dotfiles.git /projects/common/.dotfiles
RUN cd /projects/common
RUN stow --target=/home/root .dotfiles
RUN cd /home/root
RUN git clone git@github.com:iypetrov/books.git /projects/common/books

WORKDIR /root
