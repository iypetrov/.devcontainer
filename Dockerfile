FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

# Dependencies
RUN apt update && apt install -y
RUN curl 
RUN wget 
RUN git 
RUN vim 
RUN tmux 
RUN zsh 
RUN htop 
RUN fzf 
RUN unzip 
RUN build-essential 
RUN ripgrep 
RUN ca-certificates 
RUN openssh-client 
RUN sudo 
RUN make 
RUN stow
RUN software-properties-common
RUN lazygit
RUN ansible
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
