#!/bin/bash
#
# access_router.sh - bootstrap a mikrotek router from scratch via ssh
#                    This code is supposed to work on a Terraform Cloud runner which is 
#                    as of current an Ubuntu machine but not an offical service.
#                    So, be prepared to adopt or to lose this functionality.
#                    In this case, you will have to revert to local terraform.
#                    -written by selfscrum. C 2020, MIT-Licence
#                    

cd $HOME

# get sshpass. 
# Luckily, there is a c compiler on the terraform runners, so we don't need to install this, too
wget http://sourceforge.net/projects/sshpass/files/latest/download -O sshpass.tar.gz 
tar -xvf sshpass.tar.gz
rm sshpass.tar.gz
dir=`ls -1d sshpass*`
cd $dir 
./configure --prefix=$HOME/$dir/
make
make install
sleep 5

# set the new user as admin
cmd=`printf "user add name=%s password=%s group=full" $2 $3`
echo "Calling \"user add name=$2\" with user \"admin\""
$HOME/$dir/bin/sshpass -p '' ssh -o StrictHostKeyChecking=No admin@$1 $cmd
success=$?

# initial loop to ensure ssh is ready on the router
while [[ $success -ne 0 ]] ; do
    echo "still waiting for ssh..." 
    $HOME/$dir/bin/sshpass -p '' ssh -o StrictHostKeyChecking=No admin@$1 $cmd
    success=$?
    echo "ssh returns $success."
done
echo "Connected to $1"

# remove original admin for security reasons
cmd="user remove admin"
echo "Calling \"$cmd\" with user \"$2\""
$HOME/$dir/bin/sshpass -p $3 ssh -o StrictHostKeyChecking=No $2@$1 $cmd
success=$?
echo "ssh returns $success"

exit $success