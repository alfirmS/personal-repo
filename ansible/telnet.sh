echo "###ACCTION
##ad1acctionuat.adira.co.id	
10.91.5.113	9080
##ad1acctionuat.adira.co.id	
10.81.5.113	9080
##AO-WSCLARUAT03	
10.81.3.247	80
##AO-AD1ACCTRN03	
10.81.3.81	80
##AO-EXTWSUAT04	
10.81.3.26	80
##AF-WMPUAT	
10.81.3.101	8080
##AF-DISAPPUAT	
10.91.3.100	80
##AF-BRMSUAT02	
10.81.3.131	9080
10.81.3.131	80
##AO-MS2APPUAT	
10.81.3.176	8000
##AF-ESBAPPUAT01	
10.91.3.122	8000
##AF-BPMUATMS	
10.81.3.49	8080
##AF-APU001	
10.50.5.57	50000
##LB Worker Ad1checking	
149.129.236.181	80
10.161.16.40	80
##AF-FNETAPIUAT	
10.50.5.123	8080
##ad1cmsuat	
10.81.3.45	2072
##Worker CL-QA1	
10.161.16.155	30540
##Worker CL-QA2	
10.161.16.157	30541
##af-bpmuatdb	
10.81.3.46	1521
##af-bpmuat	
10.81.3.48	9443
##AF-ACCTUAT (DB) 	
10.81.3.186	1521" | (
  TCP_TIMEOUT=3
  while read host port; do
    (CURPID=$BASHPID;
    (sleep $TCP_TIMEOUT;kill $CURPID) &
    exec 3<> /dev/tcp/$host/$port
    ) 2>/dev/null
    case $? in
    0)
      echo $(date) $host $port is open;;
    1)
      echo $(date) $host  $port is closed;;
    143) # killed by SIGTERM
       echo $(date) $host $port timeouted;;
     esac
  done
  ) 2>/dev/null # avoid bash message "Terminated ..."


