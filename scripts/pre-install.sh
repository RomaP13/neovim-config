#!/bin/sh

echo "Updating packages..."
sudo apt-get -qq update

echo "Installing NeoVim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

echo "Exposing NeoVim globally..."
sudo mkdir -p /opt/nvim
sudo mv nvim.appimage /opt/nvim/nvim
path_to_add="/opt/nvim/"
export_line="export PATH=\"\$PATH:$path_to_add\""
echo "\n# Neovim\n$export_line" >> ~/.bashrc

# Create temporaty directory
mkdir ~/Downloads/tmp
cd ~/Downloads/tmp

echo "Installing xclip for system clipboard..."
sudo apt-get -qq install xclip

echo "Installing npm..."
sudo apt-get -qq install npm

echo "Installing clang..."
sudo apt-get -qq install clang

echo "Installing python3-venv..."
sudo apt-get -qq install python3-venv

echo "Installing pynvim..."
pip3 install pynvim

echo "Installing git..."
sudo apt-get -qq install git

echo "Installing unzip..."
sudo apt-get -qq install unzip

echo "Installing dependencies for telescope..."
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
curl -LO https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb
sudo dpkg -i fd_9.0.0_amd64.deb

echo "Installing JetBrainsMono font..."
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip -q JetBrainsMono.zip
mkdir ~/.local/share/fonts
mv JetBrainsMonoNerdFontMono-Medium.ttf ~/.local/share/fonts/

# Remove temporary files
echo "Cleaning up..."
cd ~
rm -rf ~/Downloads/tmp

echo "Installation complete!"
