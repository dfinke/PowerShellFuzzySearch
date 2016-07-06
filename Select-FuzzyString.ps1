function Get-FuzzyPattern {
    param(        
        $search=''
    )

    $search.ToCharArray() -join '.*?'
}

function Select-FuzzyString {
    param(        
        $search='',
        [parameter(ValueFromPipeline=$true)]
        $data
    )
    
    Begin   { $search = Get-FuzzyPattern -Search $search } 
    Process { if($data -match $search) { $data } }
}

function Get-FuzzyCommand {
    param(
        # Search String
        [Parameter(Mandatory)]
        [string]
        $Search = ''
    )

    Get-Command | Select-FuzzyString -Search $search
}

function Get-FuzzyChildItem {
        param(
        # Search String
        [Parameter(Mandatory, Position=0)]
        [string]
        $Search = '',
        
        # Specifies a path to one or more locations.
        [Parameter(Position=1,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path = $PWD,

        # Resurse
        [Parameter()]
        [switch]
        $Recurse
    )

    $params = $PSBoundParameters
    $params.Remove("Search") | Out-Null
    Get-ChildItem @params | Select-FuzzyString -Search $search
}

set-alias sfs select-fuzzystring