## Make sure that Open vSwitch is listening on TCP ports 6640 and 6653.
 
sudo ovs-vsctl show
sudo ovs-vsctl show | grep '6640\|6653'

## Make sure that OpenDaylight, Open vSwitch and the OVSDB server are listening on TCP ports 6640 and 6653.
## Note the PIDs of OpenDaylight (java), Open vSwitch and the OVSDB server.

sudo netstat -pan | grep ':6640\|:6653'

## Make sure that these PIDs match what is seen in the output of "ps".
 
ps aux

## Curl the OpenStack Horizon dashboard and make sure that there are no errors in the output.
 
curl localhost/dashboard

## Curl the OpenDaylight GUI.  Below is the expected output.
 
curl localhost:8181/index.html

## Check the OVS config.
 
sudo ovs-vsctl get Open_vSwitch . other_config

## Make sure that the neutron configuration file /etc/neutron/neutron.conf has the following ODL entries.

## Make sure that the neutron ml2 configuration file /etc/neutron/plugins/ml2/ml2_conf.ini has the following ODL entries.

## Note the neutron ml2 ODL url:
 
grep 8087 /etc/neutron/plugins/ml2/ml2_conf.ini

## Make sure that neutron-server is using the right configuration files that have the ODL entries.
 
ps aux | grep ml2

## Source userrc_early in the devstack directory and check neutron CLIs.
## Check if all the neutron agents are running fine.

source userrc_early  
neutron agent-list

## Create a neutron network, subnet and a router.
neutron net-create test-net
#neutron subnet-create --name test-subnet test-net 11.11.11.0/24
neutron router-create test-router

## Curl neutron's ml2 ODL url and check if the neutron networks, subnets, routers and ports can be successfully retrieved.

curl -v -u admin:admin http://10.0.2.15:8087/controller/nb/v2/neutron/networks | grep '\"name\"'  
curl -v -u admin:admin http://10.0.2.15:8087/controller/nb/v2/neutron/subnets | grep '\"name\"'  
curl -v -u admin:admin http://10.0.2.15:8087/controller/nb/v2/neutron/routers | grep '\"name\"'  
curl -v -u admin:admin http://10.0.2.15:8087/controller/nb/v2/neutron/ports  

## Curl neutron's ml2 ODL url and check if the neutron network topology can be successfully retrieved.

curl -v -u admin:admin http://10.0.2.15:8087/restconf/operational/network-topology:network-topology

## Check the OpenFlow 1.3 table in the OVS bridge br-int:

sudo ovs-ofctl -O OpenFlow13 dump-flows br-int

## Connect to the ODL karaf shell, and check if the neutron network, subnet and router that were created are captured in the ODL logs.

cd ~/distribution-karaf-0.5.2-Boron-SR2/
sudo bash -c "export JAVA_HOME=/usr/java/jdk1.8.0_112 ; ./bin/client"
opendaylight-user@root>log:display | grep test-net
opendaylight-user@root>log:display | grep test-subnet
opendaylight-user@root>log:display | grep test-router

## Check ODL OpenFlow statistics and session statistics in the karaf shell:

opendaylight-user@root>ofp:showstats  
opendaylight-user@root>ofp:show-session-stats  

## Check the ODL web end points in the karaf shell.

opendaylight-user@root>web:list  

## Make sure that the ODL configurations have the right entries for OpenStack neutron and Open vSwitch.

opendaylight-user@root>config:list  | grep -i ovs

## Hit CTRL+d to exit from karaf shell.

## Since we have setup port forwarding on VirtualBox, the following links can be accessed on the Mac laptop to retrieve the neutron networks, subnets, ports and routers from neutron's ml2 ODL url!
## http://localhost:8187/controller/nb/v2/neutron/networks
## http://localhost:8187/controller/nb/v2/neutron/subnets
## http://localhost:8187/controller/nb/v2/neutron/ports
## http://localhost:8187/controller/nb/v2/neutron/routers

## On the laptop, access the network topology at the ODL web endpoint using RESTCONF.
## http://localhost:8282/restconf/operational/network-topology:network-topology

## The OpenStack Horizon dashboard can be accessed on the Mac laptop at http://localhost:8080/.  Use the username admin and password nomoresecret to login into Horizon.
