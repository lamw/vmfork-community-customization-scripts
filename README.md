# VMFork aka Instant Clone Community Customization Scripts

![](vmfork-aka-instant-clone.png)

This repository contains a collection of community contributed OS customization scripts that are to be used with VMware's Instant Clone PowerCLI Extension Fling.

## Requirements

* vSphere 6.0 (vCenter Server + ESXi 6.0)
* ![PowerCLI 6.0 Release 1](https://my.vmware.com/group/vmware/get-download?downloadGroup=PCLI600R1)
* ![Instant Clone PowerCLI Extensions](https://labs.vmware.com/flings/powercli-extensions)

## How it works

Each top level directory represents an OS which has been tested against the Instant Clone PowerCLI Extension cmdlets. Within each directory, it should include a minimum of a pre and post-customization script along with the a corresponding PowerCLI driver script which demonstrates the use of the pre/post script. There may be additional scripts that are included which should have further instructions added to a notes.txt file.

Here is an example of an Instant Clone customization script for ESXi 6.0. Each script should contain the OS name as noted at the top level directory.

```
├── esxi60
│   ├── notes.txt
│   ├── post-esxi60.sh
│   ├── pre-esxi60.sh
│   ├── prep-esxi60.sh
│   └── vmfork-esxi60.ps1
```

To use the ESXi 6.0 Instant Clone customization script, you would run the PowerCLI driver script like the following:

```
.\vmfork-esxi60.ps1
```

## Contribution

Feel free to submit pull requests for either bug fixes or adding additional Instant Clone customization scripts following a similar directory structure.
