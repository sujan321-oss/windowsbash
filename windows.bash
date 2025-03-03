#!/bin/bash


# resource group
group_name="WindowsServer"
location="centralindia"

#public ip
ip_name="windowsserver"
ip_sku="Basic"

# virtual network
vnet_name="windows_vnet"
address_prefix="10.0.0.0/16"
subnet_name="windows-server-subnet"
subnet_prefixes="10.0.0.0/24"


#virtual machine
vm_name="windowsweb"
vm_image="Win2019Datacenter"
public_ip_sku="Basic"
username="khuma"
password="P00kharelk##"

#network interface
NIC_name="windows-server-nic"

#NSG
nsg_name="NSGwindows"

#asg
asg_name="ASGwindows"

# creating a resource group
create_resource_group(){
    echo "------------------ creating resource group -------------------"
    az group create\
            --name "$group_name"\
            --location "$location"

   echo "----------------------resource group created sucessfully-------------"
}


#create public ip
create_public_ip(){
     echo "_____________________creating a public ip_________________"
     az network public-ip create\
             --resource-group "$group_name"\
             --name "$ip_name"\
             --version "IPv4"\
             --sku  "$ip_sku"
}



# create the virtual network
create_vnet(){
   echo "---------creating a virtual network--------"
   az network vnet create\
           --name "$vnet_name"\
           --resource-group "$group_name"\
           --address-prefix "$address_prefix"\
           --subnet-name "$subnet_name"\
           --subnet-prefixes "$subnet_prefixes"

   echo "--------- virtual network created successfully________"

}

create_network_security_group(){
   echo "------------ creating a network security group ----------------"
    az network nsg create\
            -g "$group_name"\
            -n "$nsg_name"
    echo "------- network security group create successfully --------- "
}

create_application_security_group(){
  echo "------ creating a application security group ----------"
  az network asg create\
          -g "$group_name"\
          -n "$asg_name"
   echo " --------- application security group created successfully------"

}


create_network_interface(){
   echo "-------- creating a network interface -------"

   az network nic create\
            -g "$group_name"\
            --vnet-name "$vnet_name"\
            --subnet "$subnet_name"\
            --name "$NIC_name"\
            --network-security-group "$nsg_name"\
            --application-security-groups "$asg_name"\
            --public-ip-address "$ip_name"


   echo "------ network interface created successfully ------"
}




#creating a windows virtual machine
create_windows_vm() {
    echo "---------creating a windows_vm______________"
      az vm create\
              --resource-group "$group_name"\
              --name "$vm_name"\
              --image "$vm_image"\
              --public-ip-sku "$public_ip_sku"\
              --nics "$NIC_name"\
              --admin-username "$username"\
              --admin-password "$password"
      echo "-------virtual machine created successfully----------------"


}




create_resource_group
create_vnet
 create_application_security_group
create_network_security_group
create_public_ip
create_network_interface
create_windows_vm
