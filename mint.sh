#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
for line in `cat /etc/environment`; do export $line;done
export is_chroot=true
apt-get install jq curl git gh --no-install-recommends -yq
dpkg --configure -a
# Handle Kernel Upgrade
rm /etc/apt/apt.conf.d/01*
cat > /etc/apt/apt.conf.d/01autoremove << EOF
APT
{
  Never-MarkAuto-Sections
  {
	"metapackages";
	"contrib/metapackages";
	"non-free/metapackages";
	"restricted/metapackages";
	"universe/metapackages";
	"multiverse/metapackages";
  };

  Move-Autobit-Sections
  {
	"oldlibs";
	"contrib/oldlibs";
	"non-free/oldlibs";
	"restricted/oldlibs";
	"universe/oldlibs";
	"multiverse/oldlibs";
  };
};
EOF

# Apt init
dpkg --configure -a
apt-get update -qqqqq
apt-get install --fix-broken
apt-get autopurge -y

APT_ARGS="-qy --no-install-recommends --fix-missing --fix-broken --no-install-suggests --allow-change-held-packages --allow-downgrades"

# Apt update
apt-get update

# Delete unneeded
apt-get autopurge $APT_ARGS \
system-config-printer* cups* hunspell-* language-* aspell* avahi-* networkd-dispatcher acpi* thermald zfs* redshift* timeshift* warpinator* pix* drawing* xreader* libreoffice-* wamerican openjdk-11-jre* \
mintwelcome \
mintinstall \
whoopsie \
mintupdate \
anacron \
thunderbird* \
firefox* \
webapp* \
*-dbg \
xviewer* \
xapp-* \
samba* \
smbclient \
hexchat* \
ristretto* \
xfburn* \
hyp* \
orca* \
printer-driver* \
webcam* warpinator* whoopsie* breeze* \
transmission-* celluloid* rhythm*
# Move `/etc/apt/apt.conf.d/01autoremove` away
#mv /etc/apt/apt.conf.d/01autoremove /root || mv /tmp/01autoremove /root || true

# Upgrade System
apt-get dist-upgrade $APT_ARGS `apt list --upgradable | awk '/\//' | cut -d "/" -f1` && apt-get autopurge -y && apt-get clean
apt-get autopurge -y
# Install Hypervisor
apt-get install $APT_ARGS virtualbox virtualbox-guest-x11 virtualbox-guest-additions-iso virtualbox-qt virtualbox-ext-pack


# Install better randomness
apt-get install $APT_ARGS jitterentropy-rngd haveged git

# Install other crypto + privacy utils
add-apt-repository -y ppa:unit193/encryption
mv /etc/apt/sources.list.d/official-package-repositories.list /etc/apt/sources.list || true
apt-get update
apt-get install $APT_ARGS \
veracrypt \
zulucrypt-gui \
zulumount-gui \
keepassxc \
metadata-cleaner \
secure-delete \
tor \
torsocks \
tor-geoipdb \
obfs4proxy \
onionshare* \
nyx \
onioncircuits \
apparmor-utils \
lldb \
strace \
gdb \
clamav* \
snowflake* \
chkrootkit \
rkhunter \
binwalk \
foremost \
brotli \
scrcpy \
apt-transport* \
ddrescue* \
encfs \
cryfs

systemctl enable tor

# Upgrade to `lunar`
sed -i s'/jammy/lunar/' /etc/apt/sources.list /etc/apt/sources.list.d/*
sed -i s'/\[.*\]//' /etc/apt/sources.list.d/*
apt-get update
apt-get dist-upgrade $APT_ARGS

# Install `riseup-vpn` & `cryptsetup-nuke-password` and `cryptsetup-suspend`
apt-get install $APT_ARGS riseup-vpn cryptsetup-nuke-password cryptsetup-suspend

# Install Network utils
apt-get install $APT_ARGS pppoe macchanger wifite pixiewps reaver bully hcx* aircrack-ng john hashcat git gh pppoeconf menulibre

# Install `hblock`
HBLOCK=`mktemp -d`
cd $HBLOCK && git clone --recursive https://github.com/hectorm/hblock && cd hblock && make install && systemctl enable hblock.timer && cd && rm "/tmp/$HBLOCK" -rfv


# Install `kicksecure` Repository
cat > /etc/apt/sources.list.d/derivative.list << EOF
deb https://deb.kicksecure.com/ bookworm main
deb https://deb.whonix.org/ bookworm main
EOF
apt-get update
groupadd --system console
useradd user
adduser user console
adduser user sudo
apt-get install $APT_ARGS usability-misc lkrg* security-misc tirdad kloak sdwdate-gui bootclockrandomization timesanitycheck icon-pack-dist setup-wizard-dist \
kicksecure-base-files dist-base-files uwt
cp -rfv /usr/share/security-misc/lkrg/30-lkrg-virtualbox.conf /etc/sysctl.d
sed -i s'/#PROXY/PROXY/' /etc/sdwdate*/*
sed -i s'/#RANDOMIZE/RANDOMIZE/' /etc/sdwdate*/*
sed -i s'/user/%sudo/' /etc/sudoers.d/sdwdate*
sed -i s'/,nosmt//' /etc/default/grub.d/*
sed -i s'/nosmt=force//' /etc/default/grub.d/*
systemctl enable lkrg
deluser user

# Configure MAC randomization invisible 
cat > /usr/lib/NetworkManager/conf.d/99macrandomization.conf << EOF
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=stable
ethernet.cloned-mac-address=stable
connection.stable-id=${CONNECTION}/${BOOT}
EOF

# Configure tor
cat > /etc/tor/torrc << EOF
ClientTransportPlugin snowflake exec /usr/bin/snowflake-client -url https://snowflake-broker.torproject.net.global.prod.fastly.net/
AvoidDiskWrites 1
ConnectionPadding 1
ReducedConnectionPadding 0
CircuitPadding 1
ReducedCircuitPadding 0
VirtualAddrNetwork 10.192.0.0/10
AutomapHostsOnResolve 1
AutomapHostsSuffixes .exit,.onion
TransPort 127.0.0.1:9040 IPv6Traffic PreferIPv6 IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
SocksPort 127.0.0.1:9050 IPv6Traffic PreferIPv6 IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
ControlPort 127.0.0.1:9051
CookieAuthentication 1
DNSPort 127.0.0.1:53
HardwareAccel 0
TestSocks 1
AllowNonRFC953Hostnames 0
WarnPlaintextPorts 23,109,110,143,80
ClientRejectInternalAddresses 1
NewCircuitPeriod 5
MaxCircuitDirtiness 666
MaxClientCircuitsPending 12
UseEntryGuards 1
GuardLifetime 1days
EnforceDistinctSubnets 1
EOF
apt-get install $APT_ARGS vanguards
systemctl enable tor vanguards

# Configure Firewall
cat > /lib/systemd/system/ufw.service << EOF
[Unit]
Description=Uncomplicated firewall
Documentation=man:ufw(8)
DefaultDependencies=no
Before=network-pre.target
Wants=network-pre.target local-fs.target
After=local-fs.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/lib/ufw/ufw-init start quiet
ExecStartPost=/usr/sbin/iptables -I INPUT 1 -p icmp -j DROP
ExecStop=/lib/ufw/ufw-init stop

[Install]
WantedBy=multi-user.target
EOF
systemctl enable ufw
ufw default deny incoming

# Configure apt->tor
sed -i s'/tor+http/http/' /etc/apt/sources.list /etc/apt/sources.list.d/* && \
sed -i s'/http/tor+http/' /etc/apt/sources.list /etc/apt/sources.list.d/* && \
apt-get update
apt-get install $APT_ARGS ubiquity ubiquity-frontend-gtk  enchant-2
# Remove old kernel versions
KVERSIONS=`apt list --installed 2> /dev/null 0>/dev/null  |grep 'linux-.*.[0-9].*\/' | cut -d " " -f2 | sort -u`
for old in `for k in $KVERSIONS; do echo $k;done | cut -d '-' -f1 | head -n -1`; do apt-get autopurge $APT_ARGS $old; find / -name "*$old*" -type d -exec rm -rfv {} + 2> /dev/null; done
 # Cleanup
find / -type f -name '*.deb*' -exec rm -rfv {} + 2> /dev/null
echo 'Cleaned Debian Packages'
find / -type f -name '*.log*' -exec rm -rfv {} + 2> /dev/null
echo 'Cleared Logs'
find / -name '.*_history' -type f -exec rm -rfv {} 2> /dev/null
find / -name "mint.sh" -type f -exec rm -rfv {} + 2> /dev/null 
exit 0
