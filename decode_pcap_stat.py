import sys

def main():
    d_ip_host = {}
    with open(sys.argv[1], 'rb') as fr:
        for line in fr:
            try:
                res, ips = line.split()
                host = res.split(',')[0]
                for ip in ips.split(','):
                    d_ip_host[ip] = host
                
            except:
                pass
    
    '''
    IPv4 Endpoints
    Filter:<No Filter>
                           |  Packets  | |  Bytes  | | Tx Packets | | Tx Bytes | | Rx Packets | | Rx Bytes |
    192.168.30.99              14446      14371704       4137          302788       10309        14068916   
    222.186.49.175             11692      12874786       8611        12684946        3081          189840
    '''
    
    fw = open(sys.argv[2] + '_dns.txt', 'wb')
    cnt = len('222.186.49.175             11692      12874786       8611        12684946        3081          189840'.split())
    with open(sys.argv[2], 'rb') as fr:
        for line in fr:
            items = line.strip().split()
            if len(items) != cnt:
                fw.write(line)
                continue
                
            dns = 'none'
            try:
                dns = d_ip_host[items[0]]
            except:
                pass
            
            fw.write(line.strip() + '\t' + dns + '\n')
    fw.close()
    

if __name__ == "__main__":
    #usage: py  all_dns.txt  stat.txt
    main()