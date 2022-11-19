#!/bin/bash

#bona.anselm@gmail.com

gcloud compute networks list

gcloud compute networks subnets list --sort-by=NETWORK

gcloud compute routes list

gcloud compute firewall-rules list

gcloud compute firewall-rules delete default-allow-icmp --quiet

gcloud compute firewall-rules delete default-allow-internal --quiet

gcloud compute firewall-rules delete default-allow-rdp --quiet

gcloud compute firewall-rules delete default-allow-ssh --quiet

gcloud compute networks delete default --quiet

#Jumped creating VM step since it won't be possible without a network

gcloud compute networks create mynetwork --subnet-mode=auto

gcloud compute firewall-rules create mynetwork-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=mynetwork --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute instances create mynet-us-vm --zone=us-central1-c --machine-type=n1-standard-1 --subnet=mynetwork --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=mynet-us-vm

gcloud compute instances create mynet-eu-vm --zone=europe-west1-c --machine-type=n1-standard-1 --subnet=mynetwork --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=mynet-eu-vm

#gcloud compute ssh --zone=us-central1-c mynet-us-vm

#ping -c 3 10.132.0.2

#ping -c 3 34.78.166.77

gcloud compute networks update mynetwork --switch-to-custom-subnet-mode --quiet

gcloud compute networks create managementnet --subnet-mode=custom

gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=us-central1 --range=10.130.0.0/20

gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20

gcloud compute networks list

gcloud compute networks subnets list --sort-by=NETWORK

gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=tcp:22,tcp:3389,icmp --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules list --sort-by=NETWORK

gcloud compute instances create managementnet-us-vm --zone=us-central1-c --machine-type=f1-micro --subnet=managementsubnet-us --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=managementnet-us-vm

gcloud compute instances create privatenet-us-vm --zone=us-central1-c --machine-type=f1-micro --subnet=privatesubnet-us --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm

gcloud compute instances list --sort-by=ZONE

#gcloud compute ssh --zone=us-central1-c mynet-us-vm

#ping -c 3 35.241.240.109

#ping -c 3 34.66.11.244

#ping -c 3 34.28.209.167

#ping -c 3 10.132.0.2

#ping -c 3 10.130.0.2

#ping -c 3 172.16.0.2
