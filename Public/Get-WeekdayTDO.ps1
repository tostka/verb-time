function Get-WeekdayTDO {
    <#
    .SYNOPSIS
    Get-WeekdayTDO.ps1 - Find Next/Last Weekday date
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-20
    FileName    : Get-WeekdayTDO.ps1
    License     : MIT License
    Copyright   : (c) 2022 Todd Kadrie
    Github      : https://github.com/tostka/verb-time
    Tags        : Powershell,Time
    AddedCredit : Adam Bertram
    AddedWebsite:	https://www.pluralsight.com/blog/software-development/date-arithmetic-with-powershell
    AddedTwitter:	@adambertram
    REVISIONS
    * 2:28 PM 9/20/2022 ported into verb-time
    * 2:28 PM 9/20/2022 AB posted vers
    .DESCRIPTION
    Get-WeekdayTDO.ps1 - Find Next/Last Weekday date
    .PARAMETER  interval
    Next|Last day of the week to be found.
    .PARAMETER  date
    Origin Date (defaults to today)
    .EXAMPLE
    PS> Get-WeekdayTDO
    OPTSAMPLEOUTPUT
    OPTDESCRIPTION
    .EXAMPLE
    PS> Get-WeekdayTDO.ps1 -VERBOSE
    OPTSAMPLEOUTPUT
    OPTDESCRIPTION
    .LINK
    https://github.com/tostka/verb-time
    #>
    PARAM(
        [Parameter(Position=0,HelpMessage="Next|Last day of the week to be found.")]
        [ValidateSet("last","next")]
        $interval,
        [Parameter(Position=1,HelpMessage="Origin Date (defaults to today)")]
        [datetime]$date=(get-date )
    ) ;
    $rgxWkDays = 'Monday|Tuesday|Wednesday|Thursday|Friday' ;
    $rngLast=-1..-7 ;
    $rngNext= 1..7 ;
    switch($interval){
        'next' {$rng = $rngNext }
        'last'{$rng = $rngLast }
        default {$rng = $rngNext}
    } ;
    $rng | % {
        $day = $Date.AddDays($_);
        if ($day.DayOfWeek -match $rgxWkDays) {
            $Ret = $day.Date ;
            break ;
        } ;
    } ;
    $Ret | write-output ; 
}
