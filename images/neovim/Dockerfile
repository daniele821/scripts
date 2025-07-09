FROM fedora

# add env vars
ENV EDITOR="nvim" GOPATH="$HOME/.local/share/go"

# install needed packages
RUN dnf install -y lsd ripgrep bat git bash-completion \
    neovim git unzip wget ripgrep tree-sitter-cli nodejs npm python3 golang && \
    dnf autoremove -y && dnf clean all

# initialize neovim and bash
RUN git clone --branch complete --depth 1 https://github.com/daniele821/nvim-config /root/.config/nvim && \
    nvim --headless +StarterPack +qa 2>&1 | while read -r line; do echo -en "\r\e[2K" ; echo -n "$line" ; done && echo -en "\r\e[2K" && \
    cp /root/.config/nvim/image/bashrc /root/.bashrc

COPY gitconfig /root/.gitconfig

# set initial directory
WORKDIR /root
