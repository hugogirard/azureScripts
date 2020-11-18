# How to install the script

First create an automation account in Azure with the RunAs Account option.

Adjust the permission for the new service principal that was created, by default this give contributor role to the 
subscription level.

In this case you don't need this much level so you can adjust it or use another service principal in the script.

## Install needed powershell module in your Automation Account

By default Azure Automation still use the old Azure Automation Powershell module.

You will need to install the two needed modules to run the workbook.

To do this go to your automation account and in the search box in the blade of the automation account type modules.

Next click browse galley.

In the search bar write Accounts and press enter.

You will see Az.Accounts, you can click on this module and press import.

Next you need to install another module, do the previous step and search for Cosmos.  You will see the module Az.CosmosDB, you need to install this one.

## Create your runbook

Now you can go back to your automation account and click Create a runbook in the menu.

Enter the name of the runbook and the type need to be Powershell and click create.

Copy paste the powershell code and save and publish the runbook.

## Create a schedule

Now click on your new runbook and click link to schedule button

Create the needed schedule with the proper parameters.

You are all set