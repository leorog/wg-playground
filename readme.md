- run terraform
- gen client keypair `bin/genkeys`
- get server public-key `ssh leorog@<ip> -t "sudo wg"`
- update client config with server ip, public key and client private key [wg0-client.conf](wg0-client.conf)
- add client public-key to server peer list [peers.conf](peers.conf#L2)
- update server peer list `bin/add-peers`
- connect `sudo wg-quick up wg0-client.conf` 
- check if its working `curl https://ifconfig.me/`