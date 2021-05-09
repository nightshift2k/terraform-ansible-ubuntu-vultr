# Terraform Project: *Deploy 1-n Instances on VULTR prepared for Ansible configuration management*

## Information

This is a Terraform project allowing to deploy 1-n instances (same instance size) on Vultr as provider. It will also create SSH keys and an additional user and finally write a `hosts.cfg` in the Ansible format to perform Ansible configuration after everything has been deployed.

## Requirements

### Terraform

Terraform must be installed on the system from which the project will be executed. Start by getting terraform from their [download page](https://www.terraform.io/downloads.html) and select the appropriate package for your system, for example:

    wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip


Extract the binaries into a suitable location such as `/usr/local/bin` and make sure it is included in your PATH environmental variable.

    sudo unzip terraform_0.15.3_linux_amd64.zip -d /usr/local/bin
    
Test if terraform is accessible by checking the version number in the terminal via the command:
    
    terraform -v
    Terraform v0.15.3

### VULTR API Credentials

 - Login to your VULTR Account
 - Click on the upper right top on your name and select *API*
 - Under *Personal Access Token* click on *Enable API* 
 - Note down your *API Key*, which will be needed for Terraform later on
 - Under *Access Control* either click on *Allow All IPv4* or enter an *IP or Subnet* from which your Terraform autmation will take place
 - The API key will be needed (among few other parameters) in `terraform.tfvars` described below

## Usage

Clone this GitHub project to a local folder

    git clone https://github.com/nightshift2k/terraform-ansible-ubuntu-vultr.git
    
Rename the `terraform.tfvars.example`file to `terraform.tfvars` and change its variables to the value suited for your requirements.

Initialize the project to meet the dependencies within by executing

    terraform init
    
Verify the build plan. This will check for potential errors or wrong credentials.
    
    terraform plan
    
If the output doesn't throw any errors proceed to apply the play by executing

    terraform apply
    
To destroy all provisioned ressources you can use

    terraform destroy
    
**CAUTION:** This will irreversebly destory all instances and its configuration!

## Integration with Ansible

The project is set up to provide all necessary data (SSH Keys & host inventory) to allow ansible playbooks being executed on the provisioned instances. You will find all necessary files in the folder `output`.

To run playbooks on the provisioned instances switch to your ansible playbook directory and execute it by providing the `hosts.cfg` file to `ansible-playbook` like shown below:

    ansible-playbook -i /dev/terraform-ansible-ubuntu-vultr/output/hosts.cfg my-playbook.yml


## Project Variables

Available variables are listed below, along with default values (see `variables.tf`):

    vultr_api_key = ""
    
This is you own private API key to access the VULTR API. 

    vultr_instance_region = "nrt"
    
The region/datacenter in which instances are being created. You can browse the regions via the API described here: https://www.vultr.com/api/#operation/list-regions

    vultr_instance_plan = "vhf-2c-2gb"
    
The instance size (plan). Be aware, not all plans are available in every region, you can query this via API to ensure that the instance is availabe in the defined region via public API endpoint described here: https://www.vultr.com/api/#operation/list-available-compute-region

    vultr_instance_os_id = 387
    
The numeric id of the OS with which the instance(s) should be deployed, to get a list of all available operating systems see https://www.vultr.com/api/#operation/list-os The above value specifies *Ubuntu 20.04 x64* as the desired OS being deployed.

    instance_count = 1
    
Defines the amount of the instances, defaults to `1`

    instance_prefix = "myvps"
    
The prefix for all instances deployed, the index is appended to the prefix and defines the name of every instance, so the 5th instance would in this case be named `myvps05`

    instance_user = "myuser"
    
The login user which is created with a SSH Key, password and sudo rights. The password is created randomly and can also be shown via  `terraform output`


## License

MIT / BSD