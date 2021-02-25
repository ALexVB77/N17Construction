#Paths
$MicrosoftApplicationPath = "C:\Distr\NAV_BC_17_CU2\Applications\Application\Source\Microsoft_Application.app"
$CompanyHubPath = "C:\Distr\NAV_BC_17_CU2\Applications\CompanyHub\Source\Microsoft_Company Hub.app"
$EmailSMTPConnectorPath = "C:\Distr\NAV_BC_17_CU2\Applications\Email - SMTP Connector\Source\Microsoft_Email - SMTP Connector.app"
$EssentialBusinessHeadlinesPath = "C:\Distr\NAV_BC_17_CU2\Applications\EssentialBusinessHeadlines\Source\Microsoft_Essential Business Headlines.app"
$LatePaymentPredictionPath = "C:\Distr\NAV_BC_17_CU2\Applications\LatePaymentPredictor\Source\Microsoft_Late Payment Prediction.app"
$PayPalPaymentsStandardPath = "C:\Distr\NAV_BC_17_CU2\Applications\PayPalPaymentsStandard\Source\Microsoft_PayPal Payments Standard.app"
$SalesAndInventoryForecastPath = "C:\Distr\NAV_BC_17_CU2\Applications\SalesAndInventoryForecast\Source\Microsoft_Sales and Inventory Forecast.app"
$SalesSendToEmailPrinterPath = "C:\Distr\NAV_BC_17_CU2\Applications\SendToEmailPrinter\Source\Microsoft_Send To Email Printer.app"


# Base Application 
function UnpublishAppAndDependencies($ServerInstance, $AppName) {
    Get-NAVAppInfo -ServerInstance $ServerInstance | Where-Object { 
        (Get-NavAppInfo -ServerInstance $ServerInstance -Name $_.Name).Dependencies | Where-Object {
            $_.Name -eq $AppName
        }
    } | ForEach-Object {
        UnpublishAppAndDependencies $ServerInstance $_.Name
    }
    
    try {
        Unpublish-NavApp -ServerInstance $ServerInstance -Name $AppName
    } catch {
        Write-Output "Function 'UnpublishAppAndDependencies': Error when unpublishing extension $AppName!"
        Exit
    }
}


# Base Application 
function UninstallAndUnpublish($ServerInstance, $AppName) {
    try {
        Uninstall-NavApp -ServerInstance $ServerInstance -Name $AppName -Force
    } catch {
        Write-Output "Function 'UninstallAndUnpublish': Error when uninstalling extension $AppName!"
        Exit
    }

    try {
        UnpublishAppAndDependencies $ServerInstance  $AppName
    } catch {
        Exit
    }
}


# Any 
function PublishAndInstall($ServerInstance, $AppName, $AppPath) {
    try {
        Publish-NavApp -ServerInstance $ServerInstance -Path $AppPath -Force -SkipVerification
    } catch {
        Write-Output "Function 'PublishAndInstall': Error when publishing extension $AppName!"
        Exit
    }

    try {
        Sync-NAVApp -ServerInstance $ServerInstance -Path $AppPath -Tenant 'default'
    } catch {
        Write-Output "Function 'PublishAndInstall': Error when synchronizing extension $AppName!"
        Exit
    }

    try {
        Install-NavApp -ServerInstance $ServerInstance -Name $AppName -Force
    } catch {
        Write-Output "Function 'PublishAndInstall': Error when installing extension $AppName!"
        Exit
    }
}  


# Extension
# Example: Republish -ServerInstanceName BC170 -ApplicationName "GeneralExt" -ApplicationPath "C:\ALPOPOV\AL\DemoAL\AL\GeneralExt\NSP_GeneralExt_1.0.0.0.app"
function RepublishExtension {
    param([string]$ServerInstanceName, [string]$ApplicationName, [string]$ApplicationPath)

    if (Get-NavAppInfo -ServerInstance $ServerInstanceName -Name $ApplicationName) {
        Uninstall-NavApp -ServerInstance $ServerInstanceName -Name $ApplicationName -Force
        Unpublish-NavApp -ServerInstance $ServerInstanceName -Name $ApplicationName

        try {
            PublishAndInstall -ServerInstance $ServerInstanceName -AppName $ApplicationName -AppPath $ApplicationPath
        } catch {
            Exit
        }
    } else {
        try {
            PublishAndInstall -ServerInstance $ServerInstanceName -AppName $ApplicationName -AppPath $ApplicationPath
        } catch {
            Exit
        }
    }
}


# Base Application 
# Example: Republish -ServerInstanceName BC170 -ApplicationName "Base Application" -ApplicationPath "C:\ALPOPOV\AL\DemoAL\AL\BaseApp\Microsoft_Base Application_17.1.18256.18792.app"
function RepublishBaseApp {
    param([string]$ServerInstanceName, [string]$ApplicationName, [string]$ApplicationPath)

    try {
        UninstallAndUnpublish -ServerInstance $ServerInstanceName -AppName $ApplicationName
    } catch {
        Exit
    }

    try {
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName $ApplicationName -AppPath $ApplicationPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Application" -AppPath $MicrosoftApplicationPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Company Hub" -AppPath $CompanyHubPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Email - SMTP Connector" -AppPath $EmailSMTPConnectorPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Essential Business Headlines" -AppPath $EssentialBusinessHeadlinesPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Late Payment Prediction" -AppPath $LatePaymentPredictionPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "PayPal Payments Standard" -AppPath $PayPalPaymentsStandardPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Sales and Inventory Forecast" -AppPath $SalesAndInventoryForecastPath
        PublishAndInstall -ServerInstance $ServerInstanceName -AppName "Send To Email Printer" -AppPath $SalesSendToEmailPrinterPath
    } catch {
        Exit
    } 
}