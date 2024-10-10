#!/bin/bash

sudo apt update

echo "--- Installing build-essentials"
sudo apt install -y build-essential libreadline-dev unzip

echo "--- Installing Lua"
mkdir -p ~/lua_install
cd ~/lua_install
curl -L -R -O http://www.lua.org/ftp/lua-5.1.tar.gz
tar -zxf lua-5.1.tar.gz
cd lua-5.1
make linux test
sudo make install

echo "--- Installing Luarocks"
mkdir -p ~/luarocks_install
cd ~/luarocks_install
curl -R -O https://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
tar -zxf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure --with-lua-include=/usr/local/include
make
sudo make install

echo "--- Installing git, ripgrep, fd-find"
sudo apt install -y git ripgrep fd-find

echo "--- Linking fd-find to fd"
mkdir -p ~/.local/bin
sudo ln -s $(which fdfind) ~/.local/bin/fd

echo "--- Installing Neovim"
sudo snap install nvim --classic
#curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
#sudo rm -rf /opt/nvim
#sudo tar -C /opt -xzf nvim-linux64.tar.gz
#export PATH="$PATH:/opt/nvim-linux64/bin"

