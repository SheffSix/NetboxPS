function Add-NetboxDCIMCable {
    <#
    .NOTES
    Despite Netbox's many-to-one-to-many cable/termination model, this Cmdlet only supports a single termination
    at each end of the cable
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$A_Termination_Type,

        [Parameter(Mandatory = $true)]
        [uint16]$A_Termination_Id,

        [Parameter(Mandatory = $true)]
        [string]$B_Termination_Type,

        [Parameter(Mandatory = $true)]
        [uint16]$B_Termination_Id,

        [string]$Type,

        [string]$Status,

        [uint16]$Tenant,

        [string]$Label,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint16]$Length,

        [string]$Length_Unit,

        [string]$Description,

        [string]$Comments,

        [uint16[]]$Tags,

        [string[]]$Tags_Slug

    )

    begin {
        # Convert the Termination params into hashtbale arrays
        $PSBoundParameters.A_Terminations = @(@{object_type = $A_Termination_Type; object_id = $A_Termination_Id })
        $PSBoundParameters.B_Terminations = @(@{object_type = $B_Termination_Type; object_id = $B_Termination_Id })

        if (-not [System.String]::IsNullOrWhiteSpace($Tags_Slug)) {
            if ([System.String]::IsNullOrWhiteSpace($Tags)) {
                $PSBoundParameters.Tags = @()
            }
            foreach ($CurrentTagSlug in $Tags_Slug) {
                $CurrentTagID = (Get-NetboxTag -slug $CurrentTagSlug -ErrorAction Stop).Id
                $PSBoundParameters.Tags += $CurrentTagID
            }
        }
    }

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'cables'))

        $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary `
            $PSBoundParameters -SkipParameterByName 'Tags_Slug', 'A_Termination_Type', 'A_Termination_Id', `
            'B_Termination_Type', 'B_Termination_Id'

        $URI = BuildNewURI -Segments $URIComponents.Segments

        InvokeNetboxRequest -URI $URI -Body $URIComponents.Parameters -Method POST
    }

    end {

    }
}