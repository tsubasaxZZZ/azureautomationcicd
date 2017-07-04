#$automationAccountName =  "tsunomur0704automation"
#$runbookName = "testrunbook"
#$scriptPath = "C:\Users\tsunomur\OneDrive - Microsoft\work\Work Folders\200_Work\20170630_英検\azureautomationcicd\testrunbook.ps1"
#$RGName = "tsunomur0704automation"
#Import-AzureRMAutomationRunbook -Name $runbookName -Path $scriptPath -ResourceGroupName $RGName -AutomationAccountName $automationAccountName -Type PowerShellWorkflow 
#Publish-AzureRmAutomationRunbook -AutomationAccountName $automationAccountName -Name $runbookName -ResourceGroupName $RGName

workflow testrunbook {
    $msg = ((Get-Date).AddHours(+9)).ToString("yyyyMMdd-HHmmss") + " #Start testrunbook"
    Write-Output $msg
    
    $connectionName = "AzureRunAsConnection"
    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

        "Logging in to Azure..."
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
    Get-AzureRmVM
}
