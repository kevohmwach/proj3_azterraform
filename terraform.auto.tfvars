project_name               = "policy-gov"
environment                = "production"
admin_user_email           = "example@domain.com"
prod_location              = "westeurope" # eastasia southafricanorth
addr_space                 = "10.0.0.0/16"
prod_subnet_prefixes       = "10.0.1.0/24"
db_subnet_prefixes         = "10.0.2.0/24"
appservice_subnet_prefixes = "10.0.3.0/24"
pe_subnet_prefixes         = "10.0.4.0/24"
waf_subnet_prefix          = "10.0.5.0/24"

email_address = {
  kelvin = "kevohmwach@gmail.com"
}
custom_domain_name    = "azterraform.gradestarsolutions.com"
custom_domain_enabled = true
webapp_default_url    = "https://laravel-webapp-elora.azurewebsites.net"
prod_hostname         = "cloud.gradestarsolutions.com"
staging_hostname      = "staging.gradestarsolutions.com"