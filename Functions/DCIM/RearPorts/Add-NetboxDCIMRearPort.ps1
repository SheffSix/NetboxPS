﻿
function Add-NetboxDCIMRearPort
{
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [uint16]$Device,

        [uint16]$Module,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Label,

        [Parameter(Mandatory = $true)]
        [string]$Type,

        [string]$Color,

        [uint16]$Positions,

        [string]$Description,

        [string]$Tags

    )

    $Segments = [System.Collections.ArrayList]::new(@('dcim', 'rear-ports'))

    $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters

    $URI = BuildNewURI -Segments $URIComponents.Segments

    InvokeNetboxRequest -URI $URI -Body $URIComponents.Parameters -Method POST
}