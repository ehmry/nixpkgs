#! @shell@ -e

PATH="@bridge_utils@/sbin:@iproute@/sbin:@iptables@/sbin:@tor@/bin"

user=$SUDO_USER
[ -z "$user" ] && user=$USER

# Add the tap (guest) interface.
ip tuntap add dev @tap@ mode tap user $user

# Add the bridge (host) interface.
brctl addbr @br@
brctl addif @br@ @tap@

# Bring up the interfaces.
ip link set @tap@ up
ip addr add @hostAddr@/@prefixLength@ dev @br@
ip link set @br@ up

# Remove the the interfaces
cleanup() {
    ip link set @tap@ down
    ip link set @br@ down
    brctl delbr @br@
    ip link del @tap@
}
trap cleanup EXIT

# No forwarding off or onto the bridge.
iptables -A INPUT -i @br@ -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -i @br@ -p tcp -m tcp --dport 9050 -j ACCEPT
iptables -A INPUT -i @br@ -j REJECT

iptables -A FORWARD -i @br@ -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -o @br@ -j REJECT --reject-with icmp-port-unreachable

eval datadir=~$user/.tor

# Start Tor.
tor \
    --User $user --DataDirectory $datadir \
    --DNSPort @hostAddr@:53 \
    --SOCKSPort @hostAddr@:9050 \
    $*
