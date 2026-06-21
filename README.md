# Microsoft Power BI Gateway Troubleshooter

Created by **Dewald Pretorius**.

`Troubleshooter.ps1` collects gateway, data-source, credential, refresh, cluster, and connectivity evidence. `Repair.ps1` adds guarded `Diagnose`, `RestartGatewayService`, and `FlushDns` actions.

```powershell
.\Repair.ps1 -Action Diagnose
.\Repair.ps1 -Action RestartGatewayService -WhatIf
.\Repair.ps1 -Action RestartGatewayService -Confirm
```

The repair workflow records gateway service and endpoint state before changes, restarts `PBIEgwService` only after confirmation, and verifies that it returns to `Running`. Service repair normally requires elevation. Source-reviewed; not runtime-tested against every gateway cluster or version.
