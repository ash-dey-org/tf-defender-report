env     = "p"
region  = "auea"
company = "sa"
proj    = "defender-report"
# location = "Australia"
kvname                           = "dfn-report"
service_plan_sku                 = "B2"
str_name                         = "DefReport"
storage_account_replication_type = "LRS"
extra_tags = {
  ENV = "PRD"
}
vnet_address_space  = ["10.133.1.0/24"]
fn_sn_fa            = ["10.133.1.0/28"]
pe_fa_address_space = ["10.133.1.16/28"]
# str_address_space          = ["10.133.1.32/28"]