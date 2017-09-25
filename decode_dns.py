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
                
    fw = open(sys.argv[2] + '_dns.txt', 'wb')
    with open(sys.argv[2], 'rb') as fr:
        for line in fr:
            fw.write(line.rstrip())
            items = line.strip().split()
            for item in items:
                if item.count('.') != 3:
                    continue
                try:
                    fw.write('\t%s'%d_ip_host[item])
                except:
                    pass
            fw.write('\n')
    fw.close()
    
    
    fw = open(sys.argv[3] + '_dns.txt', 'wb')
    with open(sys.argv[3], 'rb') as fr:
        for line in fr:
            fw.write(line.rstrip())
            items = line.strip().split()
            for item in items:
                if item.count('.') != 3:
                    continue
                try:
                    fw.write('\t%s'%d_ip_host[item])
                except:
                    pass
            fw.write('\n')
    fw.close()
    

if __name__ == "__main__":
    main()