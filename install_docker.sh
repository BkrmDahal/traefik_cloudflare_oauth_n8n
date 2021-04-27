# git config --global user.email "root@gmail.com"
# git config --global user.name "root"

. /etc/os-release

CPU=$(uname -m)

# if Key issue
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Order matters, ubuntu is ID_LIKE debian
if [ "${ID}" = "ubuntu" ] || [ "${ID_LIKE}" = "ubuntu" ]; then
    DEBUNTU="ubuntu"
    RELEASE=$UBUNTU_CODENAME
elif [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    DEBUNTU="debian"
else
    echo "Unsupported distro ID=${ID}, ID_LIKE=${ID_LIKE}"
    exit 2
fi

if [ -z "${RELEASE}" ]; then
    RELEASE=$VERSION_CODENAME
fi

if [ -z "${RELEASE}" ]; then
    RELEASE=$(lsb_release -cs)
fi

ARCH=$(dpkg --print-architecture)

# Add repo
echo "# Docker
deb [arch=$ARCH] http://download.docker.com/linux/${DEBUNTU} ${RELEASE} stable
# deb-src [arch=$ARCH] http://download.docker.com/linux/${DEBUNTU} ${RELEASE} stable
" | sudo tee /etc/apt/sources.list.d/docker.list

# Remove old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install docker repo key
wget -qO- https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Install docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "install docker compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


sudo usermod -aG docker $USER

