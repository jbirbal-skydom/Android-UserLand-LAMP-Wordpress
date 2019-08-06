###Update & Upgrade.
apt update -y && apt dist-upgrade -y
###Install update manager core.
apt install update-manager-core -y
###Configure available releases to LTS.
sed -i 's/Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
###Switch repos from bionic to disco.
sed -i 's/bionic/disco/g' /etc/apt/sources.list
sed -i 's/^/#/' /etc/apt/sources.list.d/*.list
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt clean -y