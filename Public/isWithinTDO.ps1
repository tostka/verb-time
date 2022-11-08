function isWithinTDO {
    <#
    .SYNOPSIS
    isWithinTDO - Determine if specified Date is within some number of tested Days of the current time. Returns boolean on status.
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-21
    FileName    : isWithinTDO.ps1
    License     : MIT License
    Copyright   : (c) 2022 Todd Kadrie
    Github      : https://github.com/tostka/verb-time
    Tags        : Powershell,Time
    AddedCredit : Jeffrey Snover [MSFT]
    AddedWebsite:	https://devblogs.microsoft.com/powershell/datetime-utility-functions/
    AddedTwitter:	
    REVISIONS
    * 1:14 PM 9/21/2022 init, updated from concept by Jeffrey Snover in powershell team post fr back in 2006 [smile]; refactored to use a timespan instead (adds missing future date support from JS's simple example); added pipeline support, CBH fleshed it out
    .DESCRIPTION
    isWithinTDO - Determine if specified Date is within some number of tested Days of the current time. Returns boolean on status.
    .PARAMETER days
    Days interval to be tested
    .PARAMETER date
    Date to be compared to
    .PARAMETER TestDate
    Switch to test the current 'date' (mm/dd/yyyy) rather than the default test against current 'time' (MM/dd/yyyy-HH:mm) for Days interval comparison[-TestDate]
    .INPUTS
    Accepts piped input
    .OUTPUTS
    System.Boolean
    .EXAMPLE
    PS> isWithinTDO
    OPTSAMPLEOUTPUT
    OPTDESCRIPTION
    .EXAMPLE
    PS> isWithinTDO 1 (get-date )
    True
    Evaluate if output of get-date 'date' property is within 1 day of Today's date (of course), with positonal param
    .EXAMPLE
    PS> '9/23/2022' | isWithinTDO 2
        True
    Evaluate if today is within 2 days of specified date, demo pipeline support
    PS> '8/1/1902','12:39 PM 9/21/2022','1/1/2023' | isWithinTDO 3
        False
        True
        False
    Demo pipeline support feeding an array of mixed dates through, evaluating if current date is within 3 days of each.
    .EXAMPLE
    PS> isWithinTDO 3 @((get-date ).AddDays(-3),(get-date ).AddDays(3),(get-date ).AddDays(-4),(get-date ).AddDays(-4)) -verbose -TestDate ;
        VERBOSE: (past date detected:09/18/2022 13:34:55)
        -TestDate specified: Testing against _date_ (rather than current time): 09/18/2022 00:00:00 against 09/21/2022 00:00:00 within 3d
        True
        VERBOSE: (future date detected09/24/2022 13:34:55)
        -TestDate specified: Testing against _date_ (rather than current time): 09/21/2022 00:00:00 against 09/24/2022 00:00:00 within 3d
        True
        VERBOSE: (past date detected:09/17/2022 13:34:55)
        -TestDate specified: Testing against _date_ (rather than current time): 09/17/2022 00:00:00 against 09/21/2022 00:00:00 within 3d
        False
        VERBOSE: (past date detected:09/17/2022 13:34:55)
        -TestDate specified: Testing against _date_ (rather than current time): 09/17/2022 00:00:00 against 09/21/2022 00:00:00 within 3d
        False
    Demo an array of mixed dates is within 3 days (positional param), using -TestData switch (which compares strict 'date's of current day and specified date), with verbose output.
    .LINK
    https://github.com/tostka/verb-time
    #>
    PARAM(
        [Parameter(Position=0,Mandatory=$True,HelpMessage="Days interval to be tested[-Days 2]")]
        [int]$days,
        [Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$true,HelpMessage="Date to be compared to[-Date '8/2/2022']")]
        [datetime[]]$date,
        [Parameter(HelpMessage="Switch to test the current 'date' (mm/dd/yyyy) rather than the default test against current 'time' (MM/dd/yyyy-HH:mm) for Days interval comparison[-TestDate]")]
        [switch]$TestDate
    ) ;
    PROCESS {
        $Now=(get-date) ;
        foreach($item in $date) {
            if($item -le $Now){
                write-verbose "(past date detected:$($item))" ; 
                $start = $item ;
                $end = (get-date ) ;
            }else{
                write-verbose "(future date detected:$($item))" ; 
                $start = (get-date ) ;
                $end = $item ;
            } ; 
            if($TestDate){
                $start = $start.date ;
                $end = $end.date ;
                $smsg = "-TestDate specified: Testing against _date_ (rather than current time):" ; 
            } else {
                $smsg = "Testing:" ;
            };
            $smsg += " $($start) against $($end) within $($days)d" ;
            write-verbose $smsg ; 
            [boolean]((New-TimeSpan -Start $start  -end $end).days -le $days) | write-output ; 
        } ; 
    } ;  # PROC-E 
}
