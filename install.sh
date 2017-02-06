## Clone the DevStack Newton repository

git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton
 
# Use useradd and passwd to create a new stack user, and give sudo access to the stack user by typing visudo, adding "stack   ALL=(ALL)   ALL" under "root    ALL=(ALL)   ALL", and save the file.

## Install Java 1.8.0

wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm  
sudo yum localinstall jdk-8u112-linux-x64.rpm   
java -version  
rm -rf jdk-8u112-linux-x64.rpm

## Install OpenDaylight Boron

wget https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.5.2-Boron-SR2/distribution-karaf-0.5.2-Boron-SR2.tar.gz  
tar xvfz distribution-karaf-0.5.2-Boron-SR2.tar.gz   
rm -rf distribution-karaf-0.5.2-Boron-SR2.tar.gz  
cd distribution-karaf-0.5.2-Boron-SR2/  
export JAVA_HOME=/usr/java/jdk1.8.0_112  
echo $JAVA_HOME

cd ~/distribution-karaf-0.5.2-Boron-SR2/

## Start the OpenDaylight server
 
sudo bash -c "export JAVA_HOME=/usr/java/jdk1.8.0_112 ; ./bin/start"  
 
## Wait for 5 minutes so that the ODL boron server is up.
## Start OpenDaylight client and connect to the karaf shell.

sudo bash -c "export JAVA_HOME=/usr/java/jdk1.8.0_112 ; ./bin/client"  
 
## List the available ODL boron features in karaf shell.
 
opendaylight-user@root>feature:list  
 
## In the karaf shell, install the odl-netvirt-openstack bundle, dlux and their dependencies needed for OpenStack neutron.
 
opendaylight-user@root>feature:install odl-netvirt-openstack odl-dlux-core odl-mdsal-apidocs  
 
## List the installed ODL neutron northbound features.
 
opendaylight-user@root>feature:list -i | grep -i neutron  
 
## List the installed ODL OVS southbound features.
 
opendaylight-user@root>feature:list -i | grep -i ovs  
 
## List the installed ODL netvirt OpenStack features.
 
opendaylight-user@root>feature:list -i | grep -i openstack  
 
## Hit CTRL+d to exit from karaf shell.
 
## Make sure that Open vSwitch's version is >= 2.5.0
 
ovs-vsctl --version
