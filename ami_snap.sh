#!/bin/bash

# AWS Key
export AWS_ACCESS_KEY=''
export AWS_SECRET_KEY=''


# Create AMIs from existing instances without reboot and putting the date next to the name
 ec2-describe-instances | grep instance | grep Name | awk '{print "Creating Image From -> " $3;
    system("ec2-create-image --name " $5 "-$(date +%F) --no-reboot " $3)
    }'

# Delete AMI's older than 14 days
 ec2-describe-images | grep `date +%m-%d --date '14 day ago'` | awk '{print "Deregistering-> " $2;
    system("ec2-deregister " $2)
    }'
