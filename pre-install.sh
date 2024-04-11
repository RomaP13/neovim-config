#!/bin/sh

# Update packages
sudo apt update

# Install NeoVim
cd Downloads/
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

# Expose nvim globally
sudo mkdir -p /opt/nvim
sudo mv nvim.appimage /opt/nvim/nvim
path_to_add="/opt/nvim/"
export_line="export PATH=\"\$PATH:$path_to_add\""
echo "\n# Neovim\n$export_line" >> ~/.bashrc

# Install xclip for system clipboard
sudo apt install xclip

# Install tree
sudo apt install tree

# Dependencies for telescope
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb

curl -LO https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb
sudo dpkg -i fd_9.0.0_amd64.deb

# Remove downloaded packages
rm fd_9.0.0_amd64.deb
rm ripgrep_13.0.0_amd64.deb
