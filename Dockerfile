FROM alpine:3.14

COPY --from=steven0351/tree-sitter:latest /usr/bin/tree-sitter /usr/local/bin

RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/main > /etc/apk/repositories && \
  echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
  apk add git curl build-base linux-headers nodejs npm py3-pip python3-dev neovim ripgrep fzf && \
  pip3 install neovim-remote 

ENV USER_BIN_DIR /usr/local/bin
ENV LVBRANCH master

RUN pip3 install pynvim && \
  git clone https://github.com/wbthomason/packer.nvim ~/.local/share/lunarvim/site/pack/packer/start/packer.nvim && \
  mkdir -p ~/.local/share/lunarvim && \
  git clone --branch "$LVBRANCH" https://github.com/lunarvim/lunarvim.git ~/.local/share/lunarvim/lvim && \
  mkdir -p "$HOME/.config/lvim" && \
  cp "$HOME/.local/share/lunarvim/lvim/utils/bin/lvim" "$USER_BIN_DIR" && \
  chmod a+rx "$USER_BIN_DIR"/lvim && \
  cp "$HOME/.local/share/lunarvim/lvim/utils/installer/config.example-no-ts.lua" "$HOME/.config/lvim/config.lua" && \
  nvim -u ~/.local/share/lunarvim/lvim/init.lua --cmd "set runtimepath+=~/.local/share/lunarvim/lvim" --headless \
  +'autocmd User PackerComplete sleep 100m | qall' \
  +PackerInstall && \
  nvim -u ~/.local/share/lunarvim/lvim/init.lua --cmd "set runtimepath+=~/.local/share/lunarvim/lvim" --headless \
  +'autocmd User PackerComplete sleep 100m | qall' \
  +PackerSync && \
  cp "$HOME/.local/share/lunarvim/lvim/utils/installer/config.example.lua" "$HOME/.config/lvim/config.lua" && \
  echo 'export PATH=$HOME/.config/lunarvim/utils/bin:$PATH' >>~/.bashrc

