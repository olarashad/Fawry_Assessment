
# **Troubleshooting Internal Web Dashboard Connectivity**



### **1. Verify DNS Resolution:**
- **Compare resolution from /etc/resolv.conf DNS vs 8.8.8.8**  
  first thing i’ll do is check what DNS my system is using by looking inside /etc/resolv.conf 
  ```bash
   cat /etc/resolv.conf
  ```
  then i’ll test resolving internal.example.com normally using the system DNS
  ```bash
  nslookup internal.example.com
  ```
  then i’ll use Google’s DNS 8.8.8.8 to compare and see if it’s a local DNS issue
  ```bash
  nslookup internal.example.com 8.8.8.8
  ```
  if the system DNS fails but Google’s DNS works then it’s definitely a problem with our internal DNS server not the service itself :(




### **2. Diagnose Service Reachability:**

- **First, check with curl if the service actually responds**  
  ```bash
  curl -I http://internal.example.com
  curl -I https://internal.example.com
  ```
  if service is up
  ```bash
  
  ```
  If broken
  ```bash
  ```
  
- **Check if the port is open using telnet**  
  ```bash
  telnet internal.example.com 80
  telnet internal.example.com 443
  ```
  if good :thumbsup:	
  ```bash
  ```
  if not then it refares to firewall or network fail
  ```bash
  ```

-**Check locally if something is listening using netstat**
```bash
netstat -tuln | grep ':80\|:443'
```
if the service is listening the out should look like that 
```bash
```
if there's no output that means nothing is running on server :tired_face:

### **3. Trace the Issue**
okay, so here’s what could be going wrong :monocle_face:

**1. Maybe the DNS server is messed up or misconfigured, so when people try to resolve internal.example.com, it just fails**

**2. It could also be that someone changed the DNS record recently, and it’s still in the middle of propagating, so not everyone sees the update yet**

**3. A firewall might be blocking traffic to port 80 or 443, even though the service itself is up**

**4. Or maybe the web server is simply down — like, the service is dead but DNS is still pointing to it**

**5. Could also be some weird network issue — like routing problems, broken VLANs, or just bad configs somewhere in the middle**

### **4. Propose and Apply Fixes:**

#### **1. DNS server is messed up or misconfigured**

- **How to confirm:**  
  From the previous step when I compared my DNS server vs 8.8.8.8, if I saw the system DNS failing but 8.8.8.8 working, then it's clear the internal DNS is broken.
  
- **Fix Command:**  
  I’d go and restart the DNS service on the server
  ```bash
  sudo systemctl restart named
  # or
  sudo systemctl restart bind9
  ```
  if the config is wrong, I’d fix it and reload
  ```bash
  sudo named-checkconf
  sudo systemctl reload named
  ```
#### **2. DNS record changed recently and not fully propagated**

- **How to confirm:**
  
  Since I already checked my DNS vs Google's in Step 1 here I'd just dig from a few different public DNS servers (like 8.8.8.8, 1.1.1.1, and Cloudflare) to see if they show the same IP
If they don’t match, it's just slow DNS propagation
   ```bash
   dig @8.8.8.8 internal.example.com
   dig @1.1.1.1 internal.example.com
   dig @9.9.9.9 internal.example.com
 
   ```

- **Fix Command:**

  on my machine, I can flush DNS cache and hope it helps
  ```bash
  sudo systemd-resolve --flush-caches
  ```


#### **3. Firewall blocking traffic to port 80/443**
- **How to confirm:**

  try to connect directly
  ```bash
  telnet internal.example.com 80
  telnet internal.example.com 443
  ```
  if connection refused or times out, firewall might be in the way
- **Fix Command:**

  check firewall rules on the server
  ```bash
  sudo iptables -L -n
  sudo ufw status
  ```
  allow the ports
  ```bash
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo systemctl reload ufw
  ```
  
#### **4. Web server is down but DNS still points to it**
- **How to confirm:**

  if i ran the curl command
  ```bash
  curl -I http://internal.example.com
  ```
  if it fails (connection refused, timeout), the web server is probably dead.

- **Fix Command:**

  restart the web service (like nginx, apache, etc)
  ```bash
  sudo systemctl restart nginx
  sudo systemctl status nginx
  ```
#### **5. Network/routing issues (broken VLANs, misconfigs, etc)**

- **How to confirm:**

  ping the server
  ```bash
  ping internal.example.com
  ```
  if ping fails traceroute it
  ```bash
  traceroute internal.example.com
  ```
  if traceroute dies halfway, it's a routing or network problem
 - **Fix Command:**

   check the server's ip config
   ```bash
    ip addr show
    ip route
   ```
   if the server lost its ip, reconfigure it or bounce the network service
   ```bash
   sudo systemctl restart networking
   ```
   if it's a router/switch problem, escalate it to network team (no point suffering alone :sweat_smile:)


### **BONUS :scream_cat:**

#### **1. Configure a local /etc/hosts entry to bypass DNS for testing**

   if i need to quickly test a fix I can bypass DNS completely by adding an entry directly to my /etc/hosts file
   That way my system will always resolve internal.example.com to the right ip no matter what DNS says
   ```bash
    sudo nano /etc/hosts
    #i'll add this line assuming the server ip is 192.168.1.100
    192.168.1.100  internal.example.com
   ```

#### **2. Persist DNS server settings using systemd-resolved or NetworkManager**
- **For systemd-resolved**

  if i want to permanently use a different DNS server (like Google's 8.8.8.8) I can change it in systemd
  ```bash
  sudo nano /etc/systemd/resolved.conf
  ```
  under the [Resolve] section I’d add
  ```bash
  DNS=8.8.8.8
  FallbackDNS=1.1.1.1
  ```

- **For NetworkManager**
  
  this ensures that DNS settings stay persistent after reboot
  ```bash
  sudo nmcli dev show | grep DNS
  sudo nmcli con mod "network" ipv4.dns "8.8.8.8 1.1.1.1"
  sudo nmcli con up "network"
  ```
  
