## Updates

- VMware Workstation was upgraded to version 17.5 to ensure compatibility and access to the latest features.

- The logger virtual machine was upgraded from Ubuntu 20.04 to Ubuntu 24.04.

- All logger servers were updated to the latest available software versions.

- The Domain Controller (DC) virtual machine was upgraded from Windows Server 2016 to Windows Server 2022.

- The Windows Event Forwarding (WEF) virtual machine was upgraded from Windows Server 2016 to Windows Server 2022.

- The Workstation virtual machine was migrated from Windows 10 to Windows 11.

- The subnet configuration was changed from 192.168.56.X to 192.168.57.X.

- Tested Only with VMWare Workstation 17.6


## TLDR; Installation

### download vagrant and install
```
https://developer.hashicorp.com/vagrant/downloads
```

### install vmware desktop plugin
```
vagrant plugin install vagrant-vmware-desktop
```

### download and install vagrant vmware utility
```
https://developer.hashicorp.com/vagrant/install/vmware
net.exe start vagrant-vmware-utility
```

### disable all network interfaces of unused hypervisor (vmare/virtualbox, the one you dont use)

### clone the repo
```
git clone https://github.com/hasamba/DetectionLabRevamped.git
cd DetectionLabRevamped/Vagrant
```

### RUN AS ADMIN
```
.\prepare.ps1
```

### DO NOT RUN AS ADMIN
```
vagrant up --provider=vmware_desktop
```
#or one by one
```
vagrant up logger
vagrant up dc
vagrant up wef
vagrant up win11

.\post_build_checks.ps1
```

## Tips

- disable network adapters for the hypervisor you do NOT use, for example is installing with vmware than disable virtualbox network cards (if exists)
- Install as non privileged user


## Troubleshooting

- Vagrant encountered an unexpected communications error with the Vagrant VMware Utility driver
  - check that vagrant-vmware-utility service is started
- Vagrant service failed to start
  - 1. Check event log
    2. reinstall driver
    3. `net stop winnat` & `net start winnat`
    4. `C:\HashiCorp\VagrantVMwareUtility\bin\vagrant-vmware-utility.exe certificate generate`
- A VM machine fail to install
  - try vagrant reload MACHINE_NAME —provision or vagrant destroy MACHINE_NAME -f;vagrant up MACHINE_NAME
- if all fail and you want a fresh install
  - delete the hidden folder .vagrant under vagrant and start again
- if vagrant keeps on failing with provisioning
  - enter the machine via winrm (enter-pssession -ComputerName MACHINE-DHCP-IP -Credential (Get-Credential) -Authentication Basic) and run all scripts as in vagrantfile





# Original Detection Lab Readme
## As of 2023-01-01, DetectionLab is no longer being actively maintained
![DetectionLab](./img/DetectionLab.png)

DetectionLab is tested weekly on Saturdays via a scheduled CircleCI workflow to ensure that builds are passing.

![Lint Code Base](https://github.com/clong/DetectionLab/workflows/Lint%20Code%20Base/badge.svg)
[![license](https://img.shields.io/github/license/clong/DetectionLab.svg?style=flat-square)](https://github.com/clong/DetectionLab/blob/master/license.md)
![Maintenance](https://img.shields.io/maintenance/no/2023.svg?style=flat-square)
[![GitHub last commit](https://img.shields.io/github/last-commit/clong/DetectionLab.svg?style=flat-square)](https://github.com/clong/DetectionLab/commit/master)
[![Twitter](https://img.shields.io/twitter/follow/DetectionLab.svg?style=social)](https://twitter.com/DetectionLab)

## Purpose
This lab has been designed with defenders in mind. Its primary purpose is to allow the user to quickly build a Windows domain that comes pre-loaded with security tooling and some best practices when it comes to system logging configurations. It can easily be modified to fit most needs or expanded to include additional hosts.

Read more about Detection Lab on Medium here: https://medium.com/@clong/introducing-detection-lab-61db34bed6ae

NOTE: This lab has not been hardened in any way and runs with default vagrant credentials. Please do not connect or bridge it to any networks you care about. This lab is deliberately designed to be insecure; the primary purpose of it is to provide visibility and introspection into each host.

## Primary Lab Features:
* Microsoft Advanced Threat Analytics (https://www.microsoft.com/en-us/cloud-platform/advanced-threat-analytics) is installed on the WEF machine, with the lightweight ATA gateway installed on the DC
* A Splunk forwarder is pre-installed and all indexes are pre-created. Technology add-ons are also preconfigured.
* A custom Windows auditing configuration is set via GPO to include command line process auditing and additional OS-level logging
* [Palantir's Windows Event Forwarding](http://github.com/palantir/windows-event-forwarding)  subscriptions and custom channels are implemented
* Powershell transcript logging is enabled. All logs are saved to `\\wef\pslogs`
* osquery comes installed on each host and is pre-configured to connect to a [Fleet](https://fleetdm.com/) server via TLS. Fleet is preconfigured with the configuration from [Palantir's osquery Configuration](https://github.com/palantir/osquery-configuration)
* Sysmon is installed and configured using [Olaf Hartong's open-sourced Sysmon configuration](https://github.com/olafhartong/sysmon-modular)
* All autostart items are logged to Windows Event Logs via [AutorunsToWinEventLog](https://github.com/palantir/windows-event-forwarding/tree/master/AutorunsToWinEventLog)
* Zeek and Suricata are pre-configured to monitor and alert on network traffic
* Apache Guacamole is installed to easily access all hosts from your local browser

---

## Building Detection Lab

When preparing to build DetectionLab locally, be sure to use the `prepare.[sh|ps1]` scripts inside of the Vagrant folder
to ensure your system passes the prerequisite checks for building DetectionLab.

* [Prerequisites](https://www.detectionlab.network/introduction/prerequisites/)
* [MacOS - Virtualbox or VMware Fusion](https://www.detectionlab.network/deployment/macosvm/)
* [Windows - Virtualbox or VMware Workstation](https://www.detectionlab.network/deployment/windowsvm/)
* [Linux - Virtualbox or VMware Workstation](https://www.detectionlab.network/deployment/linuxvm/)
* [AWS via Terraform](https://www.detectionlab.network/deployment/aws/)
* [Azure via Terraform & Ansible](https://www.detectionlab.network/deployment/azure/)
* [ESXi via Terraform & Ansible](https://www.detectionlab.network/deployment/esxi/)
* [HyperV](https://www.detectionlab.network/deployment/hyperv/)
* [LibVirt](https://www.detectionlab.network/deployment/libvirt/)
* [Proxmox](https://www.detectionlab.network/deployment/proxmox/)

---

## DetectionLab Documentation

The primary documentation site is located at https://detectionlab.network

* [Basic Vagrant Usage](https://www.detectionlab.network/introduction/basicvagrant/)
* [Lab Information & Credentials](https://www.detectionlab.network/introduction/infoandcreds/)
* [Troubleshooting and Known Issues](https://www.detectionlab.network/deployment/troubleshooting/)

---

## Contributing
Please do all of your development in a feature branch on your own fork of DetectionLab.
Contribution guidelines can be found here: [CONTRIBUTING.md](./CONTRIBUTING.md)

## In the Media
* [DetectionLab, Chris Long – Paul’s Security Weekly #593](https://securityweekly.com/2019/02/08/detectionlab-chris-long-pauls-security-weekly-593/)
* [TaoSecurity - Trying DetectionLab](https://taosecurity.blogspot.com/2019/01/trying-detectionlab.html)
* [Setting up Chris Long's DetectionLab](https://www.psattack.com/articles/20171218/setting-up-chris-longs-detectionlab/)
* [Detection Lab: Visibility & Introspection for Defenders](https://isc.sans.edu/forums/diary/Detection+Lab+Visibility+Introspection+for+Defenders/23135/)

## Credits/Resources
A sizable percentage of this code was borrowed and adapted from [Stefan Scherer](https://twitter.com/stefscherer)'s [packer-windows](https://github.com/StefanScherer/packer-windows) and [adfs2](https://github.com/StefanScherer/adfs2) Github repos. A huge thanks to him for building the foundation that allowed me to design this lab environment.

# Acknowledgements
* [Microsoft Advanced Threat Analytics](https://www.microsoft.com/en-us/cloud-platform/advanced-threat-analytics)
* [Splunk](https://www.splunk.com)
* [osquery](https://osquery.io)
* [Fleet](https://github.com/fleetdm/fleet)
* [Windows Event Forwarding for Network Defense](https://medium.com/@palantir/windows-event-forwarding-for-network-defense-cb208d5ff86f)
* [palantir/windows-event-forwarding](http://github.com/palantir/windows-event-forwarding)
* [osquery Across the Enterprise](https://medium.com/@palantir/osquery-across-the-enterprise-3c3c9d13ec55)
* [palantir/osquery-configuration](https://github.com/palantir/osquery-configuration)
* [Configure Event Log Forwarding in Windows Server 2012 R2](https://www.petri.com/configure-event-log-forwarding-windows-server-2012-r2)
* [Monitoring what matters — Windows Event Forwarding for everyone](https://blogs.technet.microsoft.com/jepayne/2015/11/23/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem/)
* [Use Windows Event Forwarding to help with intrusion detection](https://technet.microsoft.com/en-us/itpro/windows/keep-secure/use-windows-event-forwarding-to-assist-in-instrusion-detection)
* [The Windows Event Forwarding Survival Guide](https://hackernoon.com/the-windows-event-forwarding-survival-guide-2010db7a68c4)
* [PowerShell ♥ the Blue Team](https://blogs.msdn.microsoft.com/powershell/2015/06/09/powershell-the-blue-team/)
* [Autoruns](https://www.microsoftpressstore.com/articles/article.aspx?p=2762082)
* [TA-microsoft-sysmon](https://github.com/splunk/TA-microsoft-sysmon)
* [SwiftOnSecurity - Sysmon Config](https://github.com/SwiftOnSecurity/sysmon-config)
* [ThreatHunting](https://github.com/olafhartong/ThreatHunting)
* [sysmon-modular](https://github.com/olafhartong/sysmon-modular)
* [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
* [Hunting for Beacons](http://findingbad.blogspot.com/2020/05/hunting-for-beacons-part-2.html)
* [Velociraptor](https://github.com/Velocidex/velociraptor)
* [BadBlood](https://github.com/davidprowe/BadBlood)
* [PurpleSharp](https://github.com/mvelazc0/PurpleSharp)
* [EVTX-ATTACK-SAMPLES](https://github.com/sbousseaden/EVTX-ATTACK-SAMPLES)

# DetectionLab Sponsors
#### Last updated: 01/01/2023
I would like to extend thanks to everyone who sponsored DetectionLab over the past few years. DetectionLab is no longer actively being maintained or developed.

