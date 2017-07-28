@echo off

::ip.proto = 1,2,6,17  as icmp, igmp, tcp, udp
echo "---------------------info about udp-------------------"
tshark -2 -r %1 -R ip.proto==17 -T fields -e ip.src -e udp.srcport -e ip.dst -e udp.dstport | sort | uniq

echo "---------------------info about tcp--------------------"
tshark -2 -r %1 -R ip.proto==6 -T fields -e ip.src -e tcp.srcport -e ip.dst -e tcp.dstport | sort | uniq

echo "---------------------info about all ip----------------"
tshark -r %1 -T fields -e ip.dst | sort | uniq > stat_all_ip.txt

mkdir extract
for /F "tokens=*" %%A in (stat_all_ip.txt) do tshark -2 -r %1 -w extract\%%A.pcap -Y "ip.dst==%%A or ip.src==%%A"