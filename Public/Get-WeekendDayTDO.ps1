function Get-WeekendDayTDO {
  <#
    .SYNOPSIS
    Get-WeekendDay.ps1 - Find Next/Last Weekday date
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-20
    FileName    : Get-WeekendDay.ps1
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
    Get-WeekendDay.ps1 - Find Next/Last Weekday date
    .PARAMETER  interval
    Next|Last day of the week to be found.
    .PARAMETER  date
    Origin Date (defaults to today)
    .INPUTS
    None. Does not accepted piped input
    .OUTPUTS
    Returns a System.DateTime
    .EXAMPLE
    PS> Get-WeekendDay next
    Wednesday, September 21, 2022 12:00:00 AM
    Calculate next weekday
    .EXAMPLE
    PS> Get-WeekendDay last
    Monday, September 19, 2022 12:00:00 AM
    Calculate last weekday
    .LINK
    https://github.com/tostka/verb-time
    #>
    param(
        [Parameter(Position=0,HelpMessage="next|last")]
        [ValidateSet("last","next")]
        $interval,
        [Parameter(Position=1,HelpMessage="Origin Date (defaults to today)")]
        [datetime]$date=(get-date )
    ) ;
    $Now=(get-date) ;
    $rgxWkDays = 'Saturday|Sunday' ;
    $rngLast=-1..-7 ;
    $rngNext= 1..7 ;
    switch($interval){
        'next' {$rng = $rngNext }
        'last'{$rng = $rngLast }
        default {$rng = $rngNext}
    } ;
    $rng | % {
        $day = $Now.AddDays($_);
        if ($day.DayOfWeek -match $rgxWkDays) {
            $ret = $day.Date ;
            break ;
        } ;
    } ;
    $Ret | write-output ; 
}
