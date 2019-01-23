$connectionName = "AzureRunAsConnection"

try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

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

$Credentials =Get-AutomationPSCredential -Name 'creds'
$EmailTo= 'dev55997@service-now.com'
$EmailFrom="rubesh.n@royalcyber.com"
$rgname='temp'
$state=Get-AzureRmvm  -ResourceGroup $rgname -name 'test1vm' -status
if ($state.Statuses[1].DisplayStatus -eq "VM running")
    {
        $Subject="Azure VM Started Alert !!!! "
        $body="impact : 3-low `nurgent : 3-low `nassign : Ajin Azure `ncategory : Cloud Management"
		Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $Subject -body $body -UseSsl -Port 587 -SmtpServer 'smtp.office365.com' -credential $Credentials

    }
elseif ($state.Statuses[1].DisplayStatus -eq "VM deallocated")
    {
        $Subject="Azure VM Stopped Alert !!!! "
        $body="impact : 1-high `nurgent : 1-high `nassign : Ajin Azure `ncategory : Cloud Management"
		Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $Subject -body $body -UseSsl -Port 587 -SmtpServer 'smtp.office365.com' -credential $Credentials

    }