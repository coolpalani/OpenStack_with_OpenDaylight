#!/bin/bash

# Forward TCP port 3022 on host to TCP port 22 on guest VM so
# that host can SSH into guest VM
if ! VBoxManage showvminfo devstack-odl | grep 3022 > /dev/null
then
    VBoxManage modifyvm devstack-odl --natpf1 "SSH,TCP,,3022,,22"
fi

# Forward TCP port 8080 on host to TCP port 80 on guest VM so
# that host can access OpenStack Horizon in browser
if ! VBoxManage showvminfo devstack-odl | grep 8080 > /dev/null
then
    VBoxManage modifyvm devstack-odl --natpf1 "HTTP,TCP,,8080,,80"
fi

# Forward TCP port 6080 on host to TCP port 6080 on guest VM so
# that host can access Nova VNC console in browser
if ! VBoxManage showvminfo devstack-odl | grep 6080 > /dev/null
then
    VBoxManage modifyvm devstack-odl --natpf1 "CONSOLE,TCP,,6080,,6080"
fi

# Forward TCP port 8282 on host to TCP port 8181 on guest VM so
# that host can access OpenDaylight web GUI at
# http://localhost:8282/index.html (admin/admin)
if ! VBoxManage showvminfo devstack-odl | grep 8282 > /dev/null
then
    VBoxManage modifyvm devstack-odl --natpf1 "ODL,TCP,,8282,,8181"
fi

# Forward TCP port 8187 on host to TCP port 8087 on guest VM so
# that we can curl the OpenDaylight controller
if ! VBoxManage showvminfo devstack-odl | grep 8187 > /dev/null
then
    VBoxManage modifyvm devstack-odl --natpf1 "ODL_neutron,TCP,,8187,,8087"
fi

# Add internal network adapter for guest VM
if ! VBoxManage showvminfo devstack-odl | grep eth1 > /dev/null
then
    VBoxManage modifyvm devstack-odl --nic2 intnet
    VBoxManage modifyvm devstack-odl --intnet2 "eth1"
fi

# Remove stale entry in ~/.ssh/known_hosts on host
if [ -f ~/.ssh/known_hosts ]; then
    sed -i '' '/\[127.0.0.1\]:3022/d' ~/.ssh/known_hosts
fi
