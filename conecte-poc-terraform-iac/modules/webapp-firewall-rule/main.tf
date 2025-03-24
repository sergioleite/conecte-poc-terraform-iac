resource "azurerm_resource_group_template_deployment" "AllowRulePublic_DEV" {
  count = var.env == "dev" ? 1 : 0
  name                = "${var.function_app_name}-firewall"
  resource_group_name = var.rg-name
  deployment_mode     = "Incremental"
  template_content = <<JSON
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "variables": {
    "_force_terraform_to_always_redeploy": "${timestamp()}"
  },
  "resources": [{
     "type": "Microsoft.Web/sites/config",
         "apiVersion": "2022-09-01",
         "name": "${var.function_app_name}/web",
         "location": "East US 2",
         "properties": {
            "publicNetworkAccess": "Enabled",
            "scmIpSecurityRestrictions": [
                    {
                        "ipAddress": "AzureCloud",
                        "action": "Allow",
                        "tag": "ServiceTag",
                        "priority": 100,
                        "name": "Allow_Devops"
                    },
                    {
                        "ipAddress": "Any",
                        "action": "Deny",
                        "priority": 2147483647,
                        "name": "Deny all",
                        "description": "Deny all access"
                    }
                ],
                "scmIpSecurityRestrictionsDefaultAction": "Deny",
                "scmIpSecurityRestrictionsUseMain": false
         }
    }
  ]
}
JSON
}