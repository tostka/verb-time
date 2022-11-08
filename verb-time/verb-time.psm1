# verb-time.psm1


<#
.SYNOPSIS
verb-time - PS time-related generic functions
.NOTES
Version     : 1.0.0.0
Author      : Todd Kadrie
Website     :	https://www.toddomation.com
Twitter     :	@tostka
CreatedDate : 9/29/2022
FileName    : verb-time.psm1
License     : MIT
Copyright   : (c) 9/29/2022 Todd Kadrie
Github      : https://github.com/tostka
AddedCredit : REFERENCE
AddedWebsite:	REFERENCEURL
AddedTwitter:	@HANDLE / http://twitter.com/HANDLE
REVISIONS
* 9/29/2022 - 1.0.0.0
.DESCRIPTION
verb-time - PS time-related generic functions
.LINK
https://github.com/tostka/verb-time
#>


$script:ModuleRoot = $PSScriptRoot ;
if($script:ModuleRoot){
    $script:ModuleVersion = (Import-PowerShellDataFile -Path (get-childitem $script:moduleroot\*.psd1).fullname).moduleversion ;
} else { 
    throw "UNABLE TO RESOLVE .PSM1:`$script:moduleroot!" ; 
} ; 
$runningInVsCode = $env:TERM_PROGRAM -eq 'vscode' ;

# Array of functions that aren't supported under PsV2 loads (dynamically dropped from load under that rev)
$Psv2PublicExcl = @() ;
$Psv2PrivateExcl = @() ;
#* v NEXT LINE IS DYN EDIT LANDMARK * DO NOT REMOVE * v
#Get public and private function definition files.

<# orig template dyn include content
$functionFolders = @('Public', 'Internal', 'Classes') ;
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder ;
    If (Test-Path -Path $folderPath) {
        Write-Verbose -Message "Importing from $folder" ;
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'  ;
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Importing $($function.BaseName)" ;
            . $($function.FullName) ;
        } ;
    } ;
} ;
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName ;
#>

# updated dynincl
if( $runningInVsCode){
    if($script:ModuleRoot){
        $inferredRoot = split-path $script:ModuleRoot ;
    } else {
        $smsg = "Unable to resolve module root location!"
        write-warning $smsg ;
        throw $smsg ;
        break ;
    }
}else {
    $inferredRoot = split-path $PsScriptRoot ;
} ;
if(test-path $inferredRoot){
    $Public = @( Get-ChildItem -Path $inferredRoot -Include 'Public', 'External' -Recurse -Directory -ErrorAction SilentlyContinue | Get-ChildItem -Include *.ps1 -File -ErrorAction SilentlyContinue | where-object {$_.Extension -eq '.ps1'} ) ;
    $Private = @( Get-ChildItem -Path $inferredRoot -Include 'Private', 'Internal' -Recurse -Directory -ErrorAction SilentlyContinue | Get-ChildItem -Include *.ps1 -File -ErrorAction SilentlyContinue | where-object {$_.Extension -eq '.ps1'} ) ;
    $Classes = @( Get-ChildItem -Path $inferredRoot -Include 'Classes' -Recurse -Directory -ErrorAction SilentlyContinue | Get-ChildItem -Include *.ps1 -File -ErrorAction SilentlyContinue | where-object {$_.Extension -eq '.ps1'} ) ;

    # Following creates conditional excludes of down-rev Psv2-incompatible functions (drop them from the lists on load)
    if( ($psversiontable.psversion.major -lt 3) -AND ($Psv2PublicExcl -OR $Psv2PrivateExcl) ){
        write-host "Powershell v2 detected: removing deprecated non-Psv2-compatible functions from module" ;
        $deprecated = $public |?{$Psv2PublicExcl -contains $_.name} ;
        $Public = $public |?{$Psv2PublicExcl -notcontains $_.name} ;
        write-verbose "(PUBLIC:skipping load of incompatible modules:$($deprecated))" ;
        $deprecated = $Private |?{$Psv2PrivateExcl -contains $_.name} ;
        write-verbose "(PRIVATE:skipping load of incompatible modules:$($deprecated))" ;
        $Private = $Private |?{$Psv2PrivateExcl -notcontains $_.name} ;
    } ;
    Foreach($import in @($Public + $Private + $Classes)) {
        Try {
          Write-Verbose -Message "  Importing $($import.fullname)" ;
          . $($import.fullname) ;
        } catch {
          $smsg = "Failed to import function $($import.fullname): $_" ;
          $smsg += "`n$($_.exception.message)" ;
          Write-Error -Message $smsg
        } ;
    }  # loop-E; ;
} else {
  throw "Unable to locate `$inferredRoot folder calculated for module .psm1!" ; 
} ;  

Export-ModuleMember -Function $Public.Basename -Alias * ;
#* ^ ABOVE LINE IS DYN EDIT LANDMARK * DO NOT REMOVE * ^

