#rebuild-module.ps1

<#
.SYNOPSIS
rebuild-module.ps1 - Rebuild verb-time & publish to $localrepo
.NOTES
Version     : 1.0.0
Author      : Todd Kadrie
Website     : http://www.toddomation.com
Twitter     : @tostka / http://twitter.com/tostka
CreatedDate : 2020-03-17
FileName    : rebuild-module.ps1
License     : MIT License
Copyright   : (c) 2020 Todd Kadrie
Github      : https://github.com/tostka
Tags        : Powershell
REVISIONS
* 8:49 AM 3/17/2020 init
.DESCRIPTION
rebuild-module.ps1 - Rebuild verb-time & publish to localrepo
.PARAMETER Whatif
Parameter to run a Test no-change pass [-Whatif switch]
.INPUTS
None. Does not accepted piped input.
.OUTPUTS
None. Returns no objects or output
.EXAMPLE
.\rebuild-module.ps1 -whatif ; 
Rebuild pass with -whatif
.EXAMPLE
.\rebuild-module.ps1
Non-whatif rebuild
.LINK
https://github.com/tostka
#>
[CmdletBinding()]
PARAM(
    [Parameter(HelpMessage="Whatif Flag  [-whatIf]")]
    [switch] $whatIf
) ;
False = (SilentlyContinue -eq 'Continue') ; 
write-verbose -verbose:False "$PSBoundParameters:
Key              Value                                 
---              -----                                 
File             C:\usr\work\exch\scripts\verb-time.ps1
ModuleDesc       PS time-related generic functions     
CreateGitRepo    True                                  
CreatePublicRepo True                                  
showDebug        True                                  
whatIf           False                                 
Verbose          True" ; 

# original approach:  (required manual psd1 version update to void version clashes)
#.\process-NewModule.ps1 -ModuleName "verb-time" -ModDirPath "C:\sc\verb-time" -Repository "$localPSRepo" -Merge -RunTest -showdebug -whatif:$($whatif) ;
# better: use processbulk-NewModule.ps1 preprocessor, which verifies and handles Step-ModuleVersion version increment
.\processbulk-NewModule.ps1 -modules "verb-time" -verbose -showdebug -whatif:$($whatif) ;

