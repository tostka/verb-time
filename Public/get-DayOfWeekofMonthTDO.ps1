function get-DayOfWeekofMonthTDO {
  <#
    .SYNOPSIS
    get-DayOfWeekofMonthTDO.ps1 - Find N'th Day of the Week of the Month this year (does not support other year specifications)
    .NOTES
    Version     : 1.0.0
    Author      : Todd Kadrie
    Website     :	http://www.toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    CreatedDate : 2022-09-20
    FileName    : get-DayOfWeekofMonthTDO.ps1
    License     : MIT License
    Copyright   : (c) 2022 Todd Kadrie
    Github      : https://github.com/tostka/verb-time
    Tags        : Powershell,Time
    AddedCredit : Adam Bertram
    AddedWebsite:	https://www.pluralsight.com/blog/software-development/date-arithmetic-with-powershell
    AddedTwitter:	@adambertram
    REVISIONS
    * 4:24 PM 9/20/2022 ported into verb-time
    * 2:28 PM 9/20/2022 inspired by AB's posted functions
    .DESCRIPTION
    get-DayOfWeekofMonthTDO.ps1 - Find N'th Day of the Week of the Month this year (does not support other year specifications)
    .PARAMETER  ordinal
    N'th Day of the Week to be found [-ordinal 1].
    .PARAMETER Day
    Day of Week to be incremented to
    .INPUTS
    None. Does not accepted piped input
    .OUTPUTS
    Returns a System.DateTime
    .EXAMPLE
    PS> get-DayOfWeekofMonthTDO -ordinal 2 -day Wednesday 
    Get 2nd Wednesday of the current month
    Example using positional parameters
    .EXAMPLE
    get-DayOfWeekofMonthTDO -ordinal 3 -day Thursday -mon October -verbose
    Get 3rd Thursday in October, with verbose output
    .EXAMPLE
    get-DayOfWeekofMonthTDO 4 Thursday November
    Using positional parameters to calc the 4th Thursday in November (Thanksgiving 2022)
    .LINK
    https://github.com/tostka/verb-time
    #>
    [Alias('get-DowOfMonth')]
    param(
          [Parameter(Position=0,HelpMessage="N'th Day of the Week to be found [-ordinal 2]")]
          [int]$ordinal,
          [Parameter(Position=1,HelpMessage="Day of Week to be next/last'd to")]
          [ValidateSet('sunday','monday','tuesday','wednesday','thursday','friday','saturday')]
          [string]$Day,
          [Parameter(Position=2,HelpMessage="Month in which nth DayOfWeek of the month is to be found (defaults to current month)[-month August]")]
          $Month = [cultureinfo]::InvariantCulture.DateTimeFormat.GetMonthName((get-date).month)
    ) ;
    switch ( $Month.GetType().fullname){
        'System.String' { 
            write-verbose "`$Month:$($Month)" ; 
            try{
                $Month = (get-date "$($month) 1 $((get-date).year)").month ; 
                write-verbose "(-month $($month):recognized month name;  converting to month number...)" ;  
            } catch{
                throw "`$Month:$($Month): unrecognized month name!" ; 
                Break ; 
            }
        } 
        'System.Int32'{
            if(1..12 -contains $Month){
                write-verbose "(-month $($month):is recognized month number)" ;  
            } else { 
                throw "`$Month:$($Month): unrecognized month specification!" ; 
                Break ; 
            } ;
        } 
        default {
            throw "`$Month:$($Month): unrecognized month name!" ; 
            Break ; 
        }
    }; 
   
    $mo1 = get-date -month $Month -day 1 -year (get-date ).year; 
    #$molast = $mo1.AddMonths(1).AddDays(-1) ; 
    #$modays = $molast.day ; 
    # alt:
    $modays = [datetime]::DaysInMonth($mo1.year,$mo1.month) ; 
    $rng = 1..$($modays) ; 
    $counted = 0 ; 
    $rng | %{
        $dow = $mo1.AddDays($_);
        if($dow.DayOfWeek -eq $Day){
            $count ++ ; 
            write-verbose "`$count:$($count):$($day):$($dow.date)" ; 
            if($count -eq $ordinal){
                $ret = $dow.Date ;
                break ;
            } ; 
        } ;
    } ; 
    $Ret | write-output ;     
}
