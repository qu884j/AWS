AWS
===
AWS Scripts && Notes
----------------------

##### ami_snap.sh:

```
Create an AMI snapshot for all the running instances, without reboot and rotate AMIs older than 14 day
0 3 * * *			root			/mnt/ami_snap.sh > /var/log/ami_snap.log 2>&1
```
----------------------
