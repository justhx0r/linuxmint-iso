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
system-config-printer* cups* hunspell-* language-pack-gnome-or-base language-pack-ia-base language-pack-kn-base language-pack-gnome-ar-base language-pack-oc-base language-pack-mk-base language-pack-pl-base language-pack-gnome-gd-base language-pack-ta-base language-pack-fa-base language-pack-ko-base language-pack-gnome-as-base language-pack-gnome-bg-base language-pack-gnome-vi-base language-pack-gnome-gu-base language-pack-ml-base language-pack-gnome-hi-base language-pack-tr-base language-pack-de-base language-pack-dz-base language-pack-ca-base language-pack-en-base language-pack-gnome-ru-base language-pack-gnome-si-base language-pack-gnome-tr-base language-pack-gnome-fr-base language-pack-ug-base language-pack-gnome-kk-base language-pack-az-base language-pack-gnome-is-base language-pack-bn-base language-pack-xh-base language-pack-gnome-nl-base language-pack-gnome-lt-base language-pack-eo-base language-pack-ast-base language-pack-id-base language-pack-gnome-fur-base language-pack-af-base language-pack-cs-base language-pack-gnome-it-base language-pack-ast language-pack-ckb language-pack-crh language-pack-gnome-sk-base language-pack-fur language-pack-gnome-cs-base language-pack-gnome-km-base language-pack-sq-base language-pack-gnome-nn-base language-pack-gnome-lv-base language-pack-kab language-pack-hr-base language-pack-gnome-sl-base language-pack-nds language-pack-gnome-el-base language-pack-gnome-ia-base language-pack-gnome-kn-base language-pack-sr-base language-pack-gnome-oc-base language-pack-szl language-pack-gnome-mk-base language-pack-gnome-pl-base language-pack-gnome-ta-base language-pack-gnome-fa-base language-pack-uk-base language-pack-gnome-ko-base language-pack-br-base language-pack-es-base language-pack-gnome-ml-base language-pack-ku-base language-pack-gnome-de-base language-pack-gnome-dz-base language-pack-af language-pack-am language-pack-an language-pack-ar language-pack-as language-pack-az language-pack-be language-pack-bg language-pack-bn language-pack-br language-pack-bs language-pack-ca language-pack-cs language-pack-cy language-pack-da language-pack-de language-pack-dz language-pack-el language-pack-en language-pack-eo language-pack-es language-pack-et language-pack-eu language-pack-fa language-pack-fi language-pack-fr language-pack-ga language-pack-gd language-pack-gl language-pack-gu language-pack-he language-pack-hi language-pack-hr language-pack-hu language-pack-ia language-pack-id language-pack-is language-pack-it language-pack-ja language-pack-ka language-pack-kk language-pack-km language-pack-kn language-pack-ko language-pack-ku language-pack-lt language-pack-lv language-pack-mk language-pack-ml language-pack-mr language-pack-ms language-pack-my language-pack-nb language-pack-ne language-pack-nl language-pack-nn language-pack-oc language-pack-gnome-ca-base language-pack-or language-pack-pa language-pack-pl language-pack-pt language-pack-ro language-pack-ru language-pack-si language-pack-sk language-pack-sl language-pack-sq language-pack-sr language-pack-sv language-pack-ta language-pack-te language-pack-tg language-pack-th language-pack-tr language-pack-ug language-pack-uk language-pack-vi language-pack-xh language-pack-gnome-en-base language-pack-bs-base language-pack-gl-base language-pack-et-base language-pack-hu-base language-pack-ka-base language-pack-zh-hans language-pack-zh-hant language-pack-gnome-ug-base language-pack-gnome-az-base language-pack-nb-base language-pack-gnome-bn-base language-pack-gnome-xh-base language-pack-gnome-eo-base language-pack-pt-base language-pack-gnome-id-base language-pack-gnome-gl-base language-pack-eu-base language-pack-fi-base language-pack-gnome-nb-base language-pack-gnome-af-base language-pack-te-base language-pack-cy-base language-pack-sv-base language-pack-nds-base language-pack-gnome-sq-base language-pack-gnome-te-base language-pack-gnome-ast language-pack-gnome-cy-base language-pack-pa-base language-pack-gnome-ast-base language-pack-gnome-hr-base language-pack-gnome-ckb language-pack-am-base language-pack-gnome-crh language-pack-gnome-fur language-pack-ne-base language-pack-gnome-sr-base language-pack-gnome-kab language-pack-tg-base language-pack-ro-base language-pack-an-base language-pack-kde-zh-hans language-pack-kde-zh-hant language-pack-gnome-nds language-pack-mr-base language-pack-gnome-uk-base language-pack-ja-base language-pack-gnome-br-base language-pack-gnome-tg-base language-pack-gnome-es-base language-pack-th-base language-pack-gnome-szl language-pack-gnome-nds-base language-pack-gnome-ku-base language-pack-he-base language-pack-gnome-mr-base language-pack-ms-base language-pack-ckb-base language-pack-gnome-bs-base language-pack-crh-base language-pack-gnome-th-base language-pack-gnome-et-base language-pack-gnome-hu-base language-pack-gnome-ka-base language-pack-gnome-zh-hans language-pack-gnome-zh-hant language-pack-gnome-ms-base language-pack-gnome-pt-base language-pack-kde-ar language-pack-kde-bg language-pack-kde-bs language-pack-kde-ca language-pack-kde-cs language-pack-kde-da language-pack-kde-de language-pack-kde-el language-pack-kde-en language-pack-kde-es language-pack-kde-et language-pack-kde-eu language-pack-kde-fa language-pack-kde-fi language-pack-kde-fr language-pack-kde-ga language-pack-kde-gl language-pack-kde-he language-pack-kde-hi language-pack-kde-hr language-pack-kde-hu language-pack-kde-ia language-pack-kde-id language-pack-kde-is language-pack-kde-it language-pack-kde-ja language-pack-kde-kk language-pack-kde-km language-pack-kde-ko language-pack-kde-lt language-pack-kde-lv language-pack-kde-mr language-pack-kde-nb language-pack-kde-nl language-pack-kde-nn language-pack-kde-pa language-pack-kde-pl language-pack-kde-pt language-pack-kde-ro language-pack-kde-ru language-pack-kde-si language-pack-kde-sk language-pack-kde-sl language-pack-kde-sr language-pack-kde-sv language-pack-kde-tg language-pack-kde-th language-pack-kde-tr language-pack-kde-ug language-pack-kde-uk language-pack-kde-vi language-pack-gnome-eu-base language-pack-kde-nds language-pack-gnome-fi-base language-pack-be-base language-pack-gnome-sv-base language-pack-or-base language-pack-kab-base language-pack-ar-base language-pack-gnome-pa-base language-pack-gnome-crh-base language-pack-gnome-am-base language-pack-gnome-af language-pack-gnome-am language-pack-gnome-an language-pack-gnome-ar language-pack-gnome-as language-pack-gnome-az language-pack-gnome-be language-pack-gnome-bg language-pack-gnome-bn language-pack-gnome-br language-pack-gnome-bs language-pack-gnome-ca language-pack-gnome-cs language-pack-gnome-cy language-pack-gnome-da language-pack-gnome-de language-pack-gnome-dz language-pack-gnome-el language-pack-gnome-en language-pack-gnome-eo language-pack-gnome-es language-pack-gnome-et language-pack-gnome-eu language-pack-gnome-fa language-pack-gnome-fi language-pack-gnome-fr language-pack-gnome-ga language-pack-gnome-gd language-pack-gnome-gl language-pack-gnome-gu language-pack-gnome-he language-pack-gnome-hi language-pack-gnome-hr language-pack-gnome-hu language-pack-gnome-ia language-pack-gnome-id language-pack-gnome-is language-pack-gnome-it language-pack-gnome-ja language-pack-gnome-ka language-pack-gnome-kk language-pack-gnome-km language-pack-gnome-kn language-pack-gnome-ko language-pack-gnome-ku language-pack-gnome-lt language-pack-gnome-lv language-pack-gnome-mk language-pack-gnome-ml language-pack-gnome-mr language-pack-gnome-ms language-pack-gnome-my language-pack-gnome-nb language-pack-gnome-ne language-pack-gnome-nl language-pack-gnome-nn language-pack-gnome-oc language-pack-gnome-or language-pack-gnome-pa language-pack-gnome-pl language-pack-gnome-pt language-pack-gnome-ro language-pack-gnome-ru language-pack-gnome-si language-pack-gnome-sk language-pack-gnome-sl language-pack-gnome-sq language-pack-gnome-sr language-pack-gnome-sv language-pack-gnome-ta language-pack-gnome-te language-pack-gnome-tg language-pack-gnome-th language-pack-gnome-tr language-pack-gnome-ug language-pack-gnome-uk language-pack-gnome-vi language-pack-gnome-xh language-pack-zh-hans-base language-pack-as-base language-pack-bg-base language-pack-gnome-ne-base language-pack-szl-base language-pack-vi-base language-pack-gu-base language-pack-fur-base language-pack-hi-base language-pack-gnome-ro-base language-pack-gnome-an-base language-pack-zh-hant-base language-pack-ru-base language-pack-si-base language-pack-gnome-ja-base language-pack-ga-base language-pack-fr-base language-pack-kk-base language-pack-is-base language-pack-gnome-kab-base language-pack-nl-base language-pack-lt-base language-pack-gnome-he-base language-pack-gnome-ga-base language-pack-da-base language-pack-gnome-zh-hans-base language-pack-my-base language-pack-it-base language-pack-gnome-szl-base language-pack-gnome-da-base language-pack-sk-base language-pack-gnome-my-base language-pack-gnome-zh-hant-base language-pack-km-base language-pack-gnome-be-base language-pack-nn-base language-pack-lv-base language-pack-gnome-ckb-base language-pack-sl-base language-pack-gd-base language-pack-el-base aspell* avahi-* networkd-dispatcher acpi* thermald zfs* redshift* timeshift* warpinator* pix* drawing* xreader* libreoffice-* wamerican openjdk-11-jre* \
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
cryfs \
fzf \
bzr \
openssh-server \
tmux \
htop calamares-extensions* calamares-settings-debian calamares

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
apt-get install $APT_ARGS ubiquity ubiquity-frontend-gtk  ubiquity-casper enchant-2


# Configure dns
touch /etc/dns-enable
systemctl enable systemd-resolved

# Add lokinet
cat > /etc/apt/sources.list.d/oxen.list << EOF
deb [arch=amd64] tor+https://deb.oxen.io lunar main
EOF
curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
apt-get install $APT_ARGS lokinetmon python3-geoip* lokinet-bin lokinet lokinet-gui
sed -i s'/#reachable=.*/reachable=false/' /etc/loki/lokinet.ini
sed -i s'/#upstream=.*/upstream=127.0.0.1/' /etc/loki/lokinet.ini
sed -i s'/hops=.*/hops=8/' /etc/loki/lokinet.ini


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
