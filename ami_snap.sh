#!/bin/bash
#
# Name:         ami_snap.sh
# DESCRIPTION:  Backup EC2 running instances as AMI/Image
# REQUIREMENTS: AWS Tools, AWS credentials
# CREATED:      29/12/2014 10:50:25 AM
# AUTHOR:       Ahmad Qubbaj qubbaj@hotmail.com
#
#


# AWS Credentials
export AWS_ACCESS_KEY=''
export AWS_SECRET_KEY=''


# rm Logs
> /tmp/ami.tmp
> /tmp/snap.tmp
> /var/log/ami_snap.log


( # Start Loging }-->

# Create AMIs Backup from running instances without reboot
echo '' && echo "Backup Started."
ec2-describe-instances --filter "instance-state-name=running" | grep instance | grep Name | awk '{print "Creating AMI From -> " $3;
  system("ec2-create-image --name " $5 "-$(date +%F_BACKUP) --no-reboot " $3)
  }'

# Delete AMI's older than 14 days
echo " " ; echo "Rotating AMIs"
ec2-describe-images | grep $(echo `date +%Y-%m-%d --date '14 day ago'`_BACKUP) | tee /tmp/ami.tmp | awk '{print "Deregistering-> " $2;
  system("ec2-deregister " $2 )
  }'

# Rotate Snapshots
echo "" ; echo 'Rotating Snapshots'
ec2-describe-snapshots > /tmp/snap.tmp
for ami in $(cat /tmp/ami.tmp | awk '{print $2}');do
  for line in $(cat /tmp/snap.tmp  | grep $ami | awk '{print $2}');do
    ec2-delete-snapshot $line
  done
done

) | tee /var/log/ami_snap.log # <--{ End Of Log
