FROM ubuntu:25.10
ENV DEBIAN_FRONTEND=noninteractive

# Dependencies 
RUN apt update
RUN apt install -y curl 
RUN apt install -y wget 
RUN apt install -y git 
RUN apt install -y unzip 
RUN apt install -y zsh 
RUN apt install -y stow
RUN apt install -y ansible
RUN apt install -y sudo 
RUN apt install -y vim 
RUN apt install -y tmux 
RUN apt install -y fzf 
RUN apt install -y build-essential 
RUN apt install -y ripgrep 
RUN apt install -y ca-certificates 
RUN apt install -y openssh-client 
RUN apt install -y make 
RUN apt install -y software-properties-common
RUN apt install -y lazygit
RUN rm -rf /var/lib/apt/lists/*

# User
RUN useradd -m -s /bin/zsh ipetrov
RUN usermod -aG sudo ipetrov
RUN echo "ipetrov ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ipetrov && chmod 0440 /etc/sudoers.d/ipetrov
USER ipetrov
WORKDIR /home/ipetrov

# Secrets
ARG ANSIBLE_VAULT_PASSWORD
ARG GH_USERNAME
ARG GH_PAT
RUN echo "${ANSIBLE_VAULT_PASSWORD}" > /tmp/ansible-vault-pass.txt

# Repositories
RUN mkdir -p /home/ipetrov/projects/common
RUN mkdir -p /home/ipetrov/projects/personal
RUN mkdir -p /home/ipetrov/projects/work

## common
RUN git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/vault.git /home/ipetrov/projects/common/vault

RUN find /home/ipetrov/projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN find /home/ipetrov/projects/common/vault/.aws -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN ln -sfn /home/ipetrov/projects/common/vault/.ssh /home/ipetrov
RUN ln -sfn /home/ipetrov/projects/common/vault/.aws /home/ipetrov

RUN git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/.dotfiles.git /home/ipetrov/projects/common/.dotfiles
RUN cd /home/ipetrov/projects/common
RUN stow --dir=/home/ipetrov/projects/common --target=/home/ipetrov .dotfiles
RUN cd /home/ipetrov

# Teardown
RUN find /home/ipetrov/projects/common/vault/.ssh -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN find /home/ipetrov/projects/common/vault/.aws -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
RUN rm /tmp/ansible-vault-pass.txt

CMD ["/bin/zsh"]
