﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.172
	 Created on:   	3/19/2020 11:53
	 Created by:   	Claussen
	 Organization: 	NEOnet
	 Filename:     	Set-NetboxIPAMAddress.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


function Set-NetboxIPAMAddress {
    [CmdletBinding(ConfirmImpact = 'Medium',
                   SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint16[]]$Id,
        
        [string]$Address,
        
        [object]$Status,
        
        [uint16]$Tenant,
        
        [uint16]$VRF,
        
        [object]$Role,
        
        [uint16]$NAT_Inside,
        
        [hashtable]$Custom_Fields,
        
        [uint16]$Interface,
        
        [string]$Description,
        
        [switch]$Force
    )
    
    begin {
#        Write-Verbose "Validating enum properties"
#        $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses', 0))
        $Method = 'PATCH'
#        
#        # Value validation
#        $ModelDefinition = GetModelDefinitionFromURIPath -Segments $Segments -Method $Method
#        $EnumProperties = GetModelEnumProperties -ModelDefinition $ModelDefinition
#        
#        foreach ($Property in $EnumProperties.Keys) {
#            if ($PSBoundParameters.ContainsKey($Property)) {
#                Write-Verbose "Validating property [$Property] with value [$($PSBoundParameters.$Property)]"
#                $PSBoundParameters.$Property = ValidateValue -ModelDefinition $ModelDefinition -Property $Property -ProvidedValue $PSBoundParameters.$Property
#            } else {
#                Write-Verbose "User did not provide a value for [$Property]"
#            }
#        }
#        
#        Write-Verbose "Finished enum validation"
    }
    
    process {
        foreach ($IPId in $Id) {
            $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses', $IPId))
            
            Write-Verbose "Obtaining IP from ID $IPId"
            $CurrentIP = Get-NetboxIPAMAddress -Id $IPId -ErrorAction Stop
            
            if ($Force -or $PSCmdlet.ShouldProcess($CurrentIP.Address, 'Set')) {
                $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id', 'Force'
                
                $URI = BuildNewURI -Segments $URIComponents.Segments
                
                InvokeNetboxRequest -URI $URI -Body $URIComponents.Parameters -Method $Method
            }
        }
    }
}