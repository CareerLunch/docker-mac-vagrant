#!/bin/sh

# Install node.js
# https://github.com/nodesource/distributions/blob/master/README.md#manual-installation
echo "##########"
echo "Node.js"
sudo add-apt-repository -y -r ppa:chris-lea/node.js
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save

KEYRING=/usr/share/keyrings/nodesource.gpg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null
gpg --no-default-keyring --keyring "$KEYRING" --list-keys

# Replace with the branch of Node.js or io.js you want to install: node_6.x, node_8.x, etc...
VERSION=node_16.x
KEYRING=/usr/share/keyrings/nodesource.gpg
# The below command will set this correctly, but if lsb_release isn't available, you can set it manually:
# - For Debian distributions: jessie, sid, etc...
# - For Ubuntu distributions: xenial, bionic, etc...
# - For Debian or Ubuntu derived distributions your best option is to use the codename corresponding to the upstream release your distribution is based off. This is an advanced scenario and unsupported if your distribution is not listed as supported per earlier in this README.
DISTRO="$(lsb_release -s -c)"
echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

sudo apt-get update
sudo apt-get install nodejs

sudo npm install -g n yarn
sudo n 16.11.1

# Install Azure CLI + kubectl
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions
echo "##########"
echo "Azure CLI"
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Does not work, see https://githubhot.com/repo/Azure/azure-cli/issues/20058
# AZ_REPO=$(lsb_release -cs)
AZ_REPO="hirsute"
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli
sudo az aks install-cli

# Install helm
# https://helm.sh/docs/intro/install/#from-apt-debianubuntu
echo "##########"
echo "Helm"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Install skaffold
echo "##########"
echo "skaffold"
curl -Lo skaffold "https://storage.googleapis.com/skaffold/releases/v1.32.0/skaffold-$(uname -s)-$(uname -m)"
sudo install skaffold /usr/local/bin/
rm skaffold

# Install rush
# https://rushjs.io/pages/developer/new_developer/#prerequisites
echo "##########"
echo "rush"
sudo npm install -g @microsoft/rush

# Install git-secret
echo "##########"
echo "git-secret"
cd /tmp
git clone https://github.com/sobolevn/git-secret.git git-secret
cd git-secret
make build
PREFIX="/usr/local" sudo make install
cd
rm -rf /tmp/git-secret

# No need to install gpg because Azure CLI installs it
