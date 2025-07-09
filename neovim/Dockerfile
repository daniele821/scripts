FROM fedora

# install needed packages
RUN dnf install -y lsd ripgrep bat git bash-completion \
    neovim git unzip wget ripgrep tree-sitter-cli nodejs npm python3 golang && \
    dnf autoremove -y && dnf clean all

# initialize neovim and bash
RUN git clone --branch complete --depth 1 https://github.com/daniele821/nvim-config /root/.config/nvim && \
    go telemetry off && nvim --headless +StarterPack +qa && rm -rf /root/.cache /root/.npm /root/go
COPY bashrc /root/.bashrc
COPY gitconfig /root/.gitconfig

# set initial directory
WORKDIR /root
