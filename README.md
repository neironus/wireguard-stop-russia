#### VPN servers:
* Install Wireguard in several AWS regions
* Generate wireguard configs from this services
* Wireguard HowTo:
  ``` bash
    Will be soon...
  ``` 

##### Docker swarm bombardier
* ``` mkdir -p /home/$USER/wireguard-conf ```
* Put wireguard configs to some directory (example: /home/$USER/wireguard-conf)
* Spin-up spot server on AWS with Ubuntu 20.04
* Install docker
* Add tour current user to docker group ```  sudo usermod -aG docker $USER ```
* Install wireguard package on this server ``` sudo apt install wireguard ```
* Clone [repo](https://github.com/neironus/wireguard-stop-russia.git) 
* Change directory to this repo
* Build docker image: 
    ``` bash 
    DOCKER_BUILDKIT=1 docker build --tag wireguard-stop-russia . 
    ```
* 

``` bash
# Init docker swarm
docker swarm init --default-addr-pool 192.168.0.0/16
# Create services on wireguard configs
export REPLICA_COUNT=1
export WG_CONF_DIR=/home/$USER/wireguard-conf
export WIREGUARD_PORT=51820
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; export WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i"; docker stack deploy -c docker-compose.yml $name; sleep 1; done

# Delete services
export WG_CONF_DIR=/home/$USER/wireguard-conf
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; docker stack rm $name; sleep 1; done


# List containers
docker ps 

# Get top from specific container (Get container id form prevues command)
docker top container-id 
```
``` bash
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; export WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i"; echo "$name - $WIREGUARD_CLIENT_CONFIG"; sleep 1; done

```