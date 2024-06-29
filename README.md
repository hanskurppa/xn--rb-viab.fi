# Palvelin

    testdomain.vip
    95.216.98.172
    2a01:4f9:2b:11d9::2

Palvelimena Hetzner dedikoitu.  
Intel Core i7-7700, 64 GB RAM, 1 TB NVMe SSD RAID 0, Arch Linux. 38 € / kk.

Web-palvelimena Caddy ja staattiset sivut.  

FI-domainit Domainkeskuksesta 9 € / v  
COM-domainit Cloudflaresta 8 € / v  
Muut domainit Namecheapista 8 € / v

Photoshop ja DaVinci Resolve.

# Palomuurisäännöt

Ei paikallista muuria, vain Hetzner Robot Firewall.  
Kaikki outbound sallittu.  
[Kovennettu SSH](https://github.com/hanskurppa/xn--rb-viab.fi/blob/master/etc/sshd/sshd_config).

| #  | Name | Version | Protocol | Source IP | Destination IP | Source port | Destination port | TCP flags | Action |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| #1  | icmp v4 | ipv4 | icmp |  |  |  |  |  | accept |
| #2  | ssh v4 | ipv4 | tcp | 80.222.48.0/20 |  |  | 22 |  | accept |
| #3  | http v4 | ipv4 | tcp |  |  |  | 80,443 |  | accept |
| #4  | http v6 | ipv6 | tcp |  |  |  | 80,443 |  | accept |
| #5  | quic v4 | ipv4 | udp |  |  |  | 443 |  | accept |
| #6  | quic v6 | ipv6 | udp |  |  |  | 443 |  | accept |
| #7  | tcp established v4 | ipv4 | tcp |  |  |  | 32768-65535 | ack | accept |
| #8  | tcp established v6 | ipv6 | tcp |  |  |  | 32768-65535 | ack | accept |
