function isTodayTDO {
    <#
    .SYNOPSIS
    isTodayTDO - compare specified -date 'date' to today's date. Returns boolean on status.
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-21
    FileName    : isTodayTDO.ps1
    License     : MIT License
    Copyright   : (c) 2022 Todd Kadrie
    Github      : https://github.com/tostka/verb-time
    Tags        : Powershell,Time
    AddedCredit : Jeffrey Snover [MSFT]
    AddedWebsite:	https://devblogs.microsoft.com/powershell/datetime-utility-functions/
    AddedTwitter:	
    REVISIONS
    * 12:29 PM 9/21/2022 init, updated from concept by Jeffrey Snover in powershell team post fr back in 2006 [smile]; added pipeline support, CBH fleshed it out
    .DESCRIPTION
    isTodayTDO - compare specified -date 'date' to today's date. Returns boolean on status.
    .PARAMETER date
    Date to be compared to today's date.
    .INPUTS
    Accepts piped input
    .OUTPUTS
    System.Boolean
    .EXAMPLE
    PS> isTodayTDO
    OPTSAMPLEOUTPUT
    OPTDESCRIPTION
    .EXAMPLE
    PS> isTodayTDO (get-date )
    True
    Evaluate if output of get-date 'date' property is Today's date, with positonal param
    .EXAMPLE
    PS> '9/23/2022' | isTodayTDO 
    True
    Evaluate if output of get-date 'date' property is Today's date, demo pipeline support
    PS> '8/1/1902','12:39 PM 9/21/2022','1/1/2023' | isTodayTDO
    False
    True
    False
    Demo pipeline support feeding an array of mixed dates through.
    .LINK
    https://github.com/tostka/verb-time
    #>
    PARAM(
        [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$true,HelpMessage="Date to be compared to today's date")]
        [datetime]$date
    ) ;
    BEGIN { }
    PROCESS {
        $Error.Clear() ; 
        # call func with $PSBoundParameters and an extra (includes Verbose)
        #call-somefunc @PSBoundParameters -anotherParam
    
        # - Pipeline support will iterate the entire PROCESS{} BLOCK, with the bound - $array - 
        #   param, iterated as $array=[pipe element n] through the entire inbound stack. 
        # $_ within PROCESS{}  is also the pipeline element (though it's safer to declare and foreach a bound $array param).
    
        # - foreach() below alternatively handles _named parameter_ calls: -array $objectArray
        # which, when a pipeline input is in use, means the foreach only iterates *once* per 
        #   Process{} iteration (as process only brings in a single element of the pipe per pass) 
    
        foreach($item in $date) {
            [boolean]([datetime]::Now.Date  -eq  $date.Date) | write-output ; 
        } ; 
    } ;  # PROC-E 
}
