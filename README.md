Powershell script to list StorSimple network interface information including MAC
================================================================================

            

In many cases we can obtain the IP address of a network interface via one command but get the MAC address from another command. StorSimple 8k series which runs a core version of server 2012 R2 (as of 20 June 2016) is no exception. In this case we can get
 the IP address information of the device network interfaces via the Get-HCSNetInterface cmdlet. However, to identify MAC addresses we need to use the Get-NetAdapter cmdlet. This Powershell script merges the information from both cmdlets presenting a PS Object
 collection, each of which has the following properties:


  *  InterfaceName 
  *  IPv4Address 
  *  IPv4Netmask 
  *  IPv4Gateway 
  *  MACAddress 
  *  IsEnabled 
  *  IsCloudEnabled 
  *  IsiSCSIEnabled 

Here's a sample script output:


![Image](https://github.com/azureautomation/powershell-script-to-list-storsimple-network-interface-information-including-mac/raw/master/SS-MAC1.jpg)


and a code snippet:


 

 For more information see [https://superwidgets.wordpress.com/2016/06/20/powershell-script-to-list-storsimple-network-interface-information-including-mac-addresses/](https://superwidgets.wordpress.com/2016/06/20/powershell-script-to-list-storsimple-network-interface-information-including-mac-addresses/)

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
