function get-DayOfWeekTDO {
  <#
    .SYNOPSIS
    get-DayOfWeekTDO.ps1 - Find Next/Last Named Day of the Week (DayOfWeek)
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-20
    FileName    : get-DayOfWeekTDO.ps1
    License     : MIT License
    Copyright   : (c) 2022 Todd Kadrie
    Github      : https://github.com/tostka/verb-time
    Tags        : Powershell,Time
    AddedCredit : Adam Bertram
    AddedWebsite:	https://www.pluralsight.com/blog/software-development/date-arithmetic-with-powershell
    AddedTwitter:	@adambertram
    REVISIONS
    * 2:28 PM 9/20/2022 simple variant of AdamB's get-weekday; ported into verb-time
    * 2:28 PM 9/20/2022 AB posted vers
    .DESCRIPTION
    get-DayOfWeekTDO.ps1 - Find Next/Last Day or Week
    .PARAMETER  interval
    Next|Last Day to be found [-next].
    .PARAMETER Day
    Day of Week to be next/last'd to
    .INPUTS
    None. Does not accepted piped input
    .OUTPUTS
    Returns a System.DateTime
    .EXAMPLE
    PS> $cabTues = get-DayOfWeekTDO next Tuesday ; 
    PS> $cabtues = get-date -Date $cabtues -Hour 10 -Minute 0
    PS> $cabThurs = get-DayOfWeekTDO next Thursday ; 
    PS> $cabthurs = get-date -Date $cabthurs -Hour 10 -Minute 0
    PS> if((new-timespan -start (get-date ) -End $cabtues).totaldays -lt (new-timespan -start (get-date ) -End $cabthurs).totaldays){$nextcab = $cabTues} else {$nextcab = $cabThurs} ; 
    PS> write-host "Next Scheduled CAB is $((Get-Date $nextcab -Format 'ddd MM/dd/yy HH:mmtt'))" ; 
        Next Scheduled CAB is Tue 09/27/22 10:00AM
    Demo calculation of the next Tues/Thurs 10AM scheduled CAB meeting.
    .EXAMPLE
    PS> get-DayOfWeekTDO -interval next -Day tuesday
    Thursday, September 22, 2022 12:00:00 AM
    Get date on next Thursday
    .EXAMPLE
    PS> get-DayOfWeekTDO last saturday
    Saturday, September 17, 2022 12:00:00 AM
    Example using positional parameters
    .LINK
    https://github.com/tostka/verb-time
    #>
    [Alias('get-Dow')]
    param(
          [Parameter(Position=0,HelpMessage="Next|Last Day to be found [-next Tuesday]")]
          [ValidateSet("last","next")]
          [string]$interval,
          [Parameter(Position=1,HelpMessage="Day of Week to be next/last'd to")]
          [ValidateSet('sunday','monday','tuesday','wednesday','thursday','friday','saturday')]
          [string]$Day
    ) ;
    $Now=(get-date) ;
    $rngLast=-1..-7 ;
    $rngNext= 1..7 ;
    switch($interval){
        'next' {$rng = $rngNext }
        'last'{$rng = $rngLast }
        default {$rng = $rngNext}
    } ;
    $rng | % {
        $dow = $Now.AddDays($_);
        if ($dow.DayOfWeek -eq $Day) {
            $ret = $dow.Date ;
            break ;
        } ;
    } ; 
    $Ret | write-output ; 
}
