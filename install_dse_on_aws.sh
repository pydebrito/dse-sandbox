stty sane

sudo su -
amazon-linux-extras enable corretto8
yum install -y java-1.8.0-amazon-corretto

mkdir /home/ec2-user/dse



mkfs.ext4 /dev/nvme0n1
mount /dev/nvme0n1 /home/ec2-user/dse
chown -R ec2-user: /home/ec2-user/dse


#striped volumes? (unfinished procedure
sudo pvcreate -y /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
sudo vgcreate striped_vol_group /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
sudo lvcreate -i4 -I4 -L6T -nstriped_logical_volume striped_vol_group 
#i2 for 2 volumes, here 4 volumes...

#to remove:
#sudo lvremove /dev/striped_vol_group/striped_logical_volume
#sudo vgremove striped_vol_group
#sudo pvremove -y /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1

sudo yum install -y gfs*
yum install -y lvm2-cluster gfs2-utils
yum install libguestfs-gfs2.x86_64


sudo mkfs.gfs2 -plock_nolock -j 1 /dev/striped_vol_group/striped_logical_volume

#pb here : unknown file system: GFS2 


