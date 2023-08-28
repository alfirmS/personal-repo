Different Config

1. Current Config
- File yaml menyebar dimana2 :
- manifest `.yaml` terpisah di beberapa tempat seperti service, support dan job
- tidak menggunakan config-server untuk call config properties
- value properties terdapat di config map
- tidak menggunakan helm
- tidak menggunakan kaniko
- menggunakan enpoint untuk redirect ke surronding dan database
- menggunakan secret untuk menyimpan API_KEY
- menggunakan ingress untuk swagger dan API service
1. List Manifest:
- Pod
- Deployment
- Service
- Replicaset
- HPA
- Job
- Cronjob
2. List deployment:
- ad1sales-activity  
- ad1sales-fe-web  
- ad1sales-fe-web-adm   
- ad1sales-identity  
- ad1sales-notification  
- ad1sales-product  
- ad1sales-report  
- ad1sales-transaction  
- ad1sales-user-mgmt  
- ad1sales-virtual-acc  
- ad1sales-web-adm  
3. List Service:
- ad1sales-activity       
- ad1sales-activity-lb    
- ad1sales-fe-web         
- ad1sales-fe-web-adm     
- ad1sales-identity       
- ad1sales-identity-lb    
- ad1sales-notification   
- ad1sales-notification-lb
- ad1sales-product        
- ad1sales-product-lb     
- ad1sales-report         
- ad1sales-report-lb      
- ad1sales-transaction    
- ad1sales-transaction-lb 
- ad1sales-user-mgmt      
- ad1sales-user-mgmt-lb   
- ad1sales-virtual-acc    
- ad1sales-virtual-acc-lb 
- ad1sales-web-adm        
- ad1sales-web-adm-lb     
- db-activity             
- db-notification         
- db-payment-commission   
- db-product              
- db-sched-job            
- db-transaction          
- db-user-mgmt            
- db-virtual-acc          
- extern-ad1access        
- extern-ad1primajaga     
- extern-adirabox         
- extern-fuse             
- extern-infobip          
- extern-publicaccess     
- extern-smtp             
4. List Cronjob:
- ad1sales-cncl-unp-ord         5/15 * * * *  
- ad1sales-del-cart-item        */5 * * * *  
- ad1sales-housekeeping-doc     1 */1 * * *  
- ad1sales-housekeeping-token   1 */1 * * *  
- ad1sales-payment-commission   3 1 * * *   
- ad1sales-resend-submit-ai     1 1 * * *   
- ad1sales-resend-submit-mli    3 1 * * *   
- ad1sales-sync-user-info       1 2 * * *   

