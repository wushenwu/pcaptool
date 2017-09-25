@echo off

cd %~dp1

echo "---------------------info about mac------------------" >> %~dp1log_tcp_udp.txt 2>&1
tshark -r %1 -T fields -e eth.addr | sort | uniq >> %~dp1log_tcp_udp.txt

echo "---------------------info about mac interaction------" >> %~dp1log_tcp_udp.txt 2>&1
tshark -r %1 -T fields -e eth.dst -e ip.dst | sort | uniq >> %~dp1log_tcp_udp.txt

echo "---------------------info about who is dns querying--" >> %~dp1log_tcp_udp.txt 2>&1
tshark -2 -r %1 -R udp.dstport==53 -T fields -e ip.src -e dns.qry.name | sort | uniq >> %~dp1log_tcp_udp.txt 

echo "---------------------info about dns resp and ip list--" >> %~dp1all_dns.txt 2>&1
tshark -2 -r %1 -T fields -e dns.resp.name -e dns.a | sort | uniq >> %~dp1all_dns.txt

echo "---------------------info about who is http requesting--" >> %~dp1log_tcp_udp.txt 2>&1
tshark -2 -r %1 -R tcp.dstport==80 -T fields -e ip.src -e http.request.full_uri | sort | uniq >> %~dp1log_tcp_udp.txt

echo "---------------------info about mail address------------" >> %~dp1log_tcp_udp.txt 2>&1
tshark -2 -r %1 -R "data-text-lines" -T fields -e text | grep -Eio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b' | sort | uniq >> %~dp1log_tcp_udp.txt

::ip.proto = 1,2,6,17  as icmp, igmp, tcp, udp
echo "---------------------info about udp-------------------" >> %~dp1log_tcp_udp.txt 2>&1
tshark -2 -r %1 -R ip.proto==17 -T fields -e ip.src -e udp.srcport -e ip.dst -e udp.dstport | sort | uniq >> %~dp1log_tcp_udp.txt 2>&1

echo "---------------------info about tcp--------------------" >> %~dp1log_tcp_udp.txt 2>&1
tshark -2 -r %1 -R ip.proto==6 -T fields -e ip.src -e tcp.srcport -e ip.dst -e tcp.dstport -e http.host -e ssl.handshake.extensions_server_name | sort | uniq >> %~dp1log_tcp_udp.txt 2>&1

echo "---------------------info about all ip----------------"
tshark -r %1 -T fields -e ip.dst | sort | uniq > %~dp1stat_all_ip.txt

::mkdir extract
::for /F "tokens=*" %%A in (stat_all_ip.txt) do tshark -2 -r %1 -w extract\%%A.pcap -Y "ip.dst==%%A or ip.src==%%A"

python decode_dns.py all_dns.txt  log_tcp_udp.txt stat_all_ip.txt