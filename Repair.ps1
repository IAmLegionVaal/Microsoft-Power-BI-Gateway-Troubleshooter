#requires -Version 5.1
<# Created by Dewald Pretorius. #>
[CmdletBinding(SupportsShouldProcess=$true)]
param([ValidateSet('Diagnose','RestartGatewayService','FlushDns')][string]$Action='Diagnose',[string]$OutputPath=(Join-Path ([Environment]::GetFolderPath('Desktop')) 'Power_BI_Gateway_Repair'))
$ErrorActionPreference='Stop';$service='PBIEgwService'
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null;$stamp=Get-Date -Format yyyyMMdd_HHmmss;$log=Join-Path $OutputPath "Repair_$stamp.log";function Log($m){$l='{0:u} {1}'-f(Get-Date),$m;Write-Host $l;Add-Content $log $l}
[ordered]@{Action=$Action;GatewayProcess=@(Get-Process 'Microsoft.PowerBI.EnterpriseGateway' -ErrorAction SilentlyContinue|Select-Object Name,Id,Path);Service=(Get-Service $service -ErrorAction SilentlyContinue|Select-Object Name,Status,StartType);PowerBI443=(Test-NetConnection 'api.powerbi.com' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue);ServiceBus443=(Test-NetConnection 'servicebus.windows.net' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue)}|ConvertTo-Json -Depth 5|Set-Content (Join-Path $OutputPath "PreRepair_$stamp.json")
if($Action -eq 'Diagnose'){Log '[COMPLETE] Snapshot saved.';exit 0}
try{if($Action -eq 'RestartGatewayService' -and $PSCmdlet.ShouldProcess($service,'Restart and verify gateway service')){Restart-Service $service -Force;Start-Sleep 3;if((Get-Service $service).Status -ne 'Running'){throw 'PBIEgwService did not return to Running.'}}
elseif($Action -eq 'FlushDns' -and $PSCmdlet.ShouldProcess('Windows DNS client cache','Clear')){Clear-DnsClientCache}}catch{Log "[FAILED] $($_.Exception.Message)";exit 5};Log '[COMPLETE] Repair completed.';exit 0
