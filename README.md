# Hostname

Module to set the local hostname on an AWS instance. This module is typically
used by other modules in this project so it is not usually directly called by
client code.

## Description

The module sets the hostnames on a set of instances. If the addresses for the
instances are private IPs then the hosts are accessed through a bastion proxy.
If a bastion proxy is not supplied then it is assumed the addresses are either
public IPs or public DNS names.

There are 2 methods used to set the hostname. More modern versions of Linux use
a command called `hostnamectl` which does it all (given the right options).
Older versions of Linux take a little more work. For these versions of Linux
the script does the following:
1. call `hostname` to set the hostname in the current running instance of the
   VM;
1. update `/etc/sysconfig/network` (or `/etc/HOSTNAME` on SUSE) to persist the
   hostname when the instance is rebooted; and
1. update `/etc/hosts` to associate the hostname with the loopback interface.

## Testing

This module was tested against the following operating systems:
* Amazon Linux 2
* Amazon Linux
* CentOS 7
* CentOS 6
* RHEL 7
* RHEL 6
* SUSE 15
* SUSE 11
* Ubuntu 18
* Ubuntu 14

## Input Variables

| Name | Description | Default |
| ---- | ----------- | ------- |
| `addresses` | list of either private IPs, public IPs, or public DNS names | |
| `bastion` | public IP or DNS of a bastion | "" |
| `bastion_private_key_path` | local path to the private key for bastion access | "" |
| `bastion_user` | ssh user on the bastion | "" |
| `hcount` | number of hosts | |
| `fqdns` | list of FQDNs | | |
| `private_key_path` | local path to the private key for ssh access | |
| `user` | ssh user on the hosts | |

## Outputs

| Name | Description |
| ---- | ----------- |
| `resource_ids` | provisioner resource IDs |
