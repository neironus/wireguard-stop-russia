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
* Spin-up spot server on AWS with $USER 20.04
* Install docker
* Install wireguard package on this server
* Clone repo ....
* Change directory to this repo
* Build docker image: 
    ``` bash 
    DOCKER_BUILDKIT=1 docker build --tag wireguard-stop-russia . 
    ```
* 

``` bash
# Create services on wireguard configs
export REPLICA_COUNT=1
export WG_CONF_DIR=/home/$USER/wireguard-conf
export WIREGUARD_PORT=51820
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i" docker stack deploy -c docker-compose.yml $name; sleep 1; done

# Delete services
export WG_CONF_DIR=/home/$USER/wireguard-conf
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; WIREGUARD_PORT=51820 WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i" docker stack rm $name; sleep 1; done

```