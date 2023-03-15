function Remove-NetboxDCIMCable {

    [CmdletBinding(ConfirmImpact = 'High',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [uint16[]]$Id,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($CableID in $Id) {
            $CurrentCable = Get-NetboxDCIMCable -Id $CableID -ErrorAction Stop

            if ($Force -or $pscmdlet.ShouldProcess("Name: $($CurrentCable.Name) | ID: $($CurrentCable.Id)", "Remove")) {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'cables', $CurrentCable.Id))

                $URI = BuildNewURI -Segments $Segments

                InvokeNetboxRequest -URI $URI -Method DELETE
            }
        }
    }

    end {

    }
}