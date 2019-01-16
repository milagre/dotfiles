Import-Module Pscx
Import-Module "C:\Tools\poshgit\dahlbyk-posh-git-a4faccd\src\posh-git.psm1"

Set-Location C:\projects
Remove-Variable -Force HOME
Set-Variable HOME "C:\Users\jlevitt"
$env:HOMEDRIVE="C:"
$env:HOMEPATH="\Users\jlevitt"

##### Git helpers
function Grepout($pattern)
{
    git checkout $(git branch | grep $pattern).Trim()
}

Set-Alias grout Grepout

function DeleteMergedLocal()
{
    git branch --merged | grep -v "\*" | grep -v "master" |% { git branch -d $_.Trim() }
}

Set-Alias dml DeleteMergedLocal

function ViewMergedLocal()
{
    git branch --merged | grep -v "\*" | grep -v "master"
}

Set-Alias vml ViewMergedLocal

function Coalesce($a, $b)
{
    if ($a -ne $null)
    {
        $a
    }
    else
    {
        $b
    }
}

function Select-Zip {
    [CmdletBinding()]
    Param(
        $First,
        $Second,
        $ResultSelector = { ,$args }
    )

    [System.Linq.Enumerable]::Zip($First, $Second, [Func[Object, Object, Object[]]]$ResultSelector)
}

#See possible commands here: https://tortoisegit.org/docs/tortoisegit/tgit-automation.html
function TortoiseGit($command, $path)
{
    if (-not $path)
    {
        $path = "."
    }
    & "C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:$command /path:$path
}

Set-Alias tgit TortoiseGit

function ShowUnpushedCommits
{
    git branch |% { $_.Substring(2) } |% { git log origin/$_..$_ }
}

Set-Alias git-show-unpushed-commits ShowUnpushedCommits

function ShowDeletions($rangeSpecification)
{
    git log $rangeSpecification --shortstat | sls "([\d]+) deletions" |% { $_.Matches } |% { $_.groups[1].value } | Measure-Object -Sum
}

Set-Alias git-deletions ShowDeletions

function GitChangeLog($rangeSpecification)
{
    git log --merges --grep="pull request" --pretty=format:'%C(yellow)%h%Creset - %s%n  %an %Cgreen(%cr)%C(bold blue)%d%Creset%n' $rangeSpecification
}

Set-Alias git-cl GitChangeLog

function KillSite($keep)
{
    Get-Process iisexpress |? { -Not $keep.Contains($_.Id) } | Stop-Process
}

Set-Alias ks KillSite

function DeleteBinaries($path)
{
    if (-not $path)
    {
        throw "You must supply a path"
    }
    gci $path -Recurse -Include *.exe,*.pdb,*.dll | Remove-Item
}

Set-Alias delbin DeleteBinaries

function OpenSolutions($path)
{
    $path = ?? $path "."
    . $(ls $path\*.sln)
}

Set-Alias sln OpenSolutions

function OpenAtom
{
    atom .
}

Set-Alias atm OpenAtom

function nunit($path, $Version = "cwd")
{
    $dll = $path
    $dllName = $path | Split-Path -Leaf
    if (-not $path.EndsWith(".dll"))
    {
    $dll = Join-Path $path "bin\debug\$dllName.dll" -Resolve -ErrorAction SilentlyContinue
    }

    if (-not $dll)
    {
    $dll = Join-Path $path "bin\Development\$dllName.dll" -Resolve -ErrorAction SilentlyContinue
    }

    switch($version)
    {
    "cwd" { . $(gci *tools*\NUnit\nunit-x86.exe) $dll }
    "3.6" { . "C:\Program Files\NUnit-Gui-0.3\nunit-gui.exe" $dll }
    }
}

function ChangeDirProjects
{
    cd c:\projects
}

Set-Alias projects ChangeDirProjects

function ChangeDirHaskell
{
    cd C:\projects\personal\haskell\course\4
}

Set-Alias hk ChangeDirHaskellKatas

function ChangeDirHaskellKatas
{
    cd C:\projects\personal\haskell-katas
}

Set-Alias hs ChangeDirHaskell

function cdmig
{
    cd C:\projects\agent\src\positronics_agent\v1_0\migrations
}

function EditProfile
{
    gvim $PROFILE
}

Set-Alias edit-profile EditProfile

function update-profile
{
    cp $PROFILE c:\projects\personal\dotfiles\Microsoft.PowerShell_profile.ps1
}

New-Alias which get-command

function pull
{
    git save
    git pullr
    git pop
}

function off
{
    Stop-Computer -Force -AsJob
}

function Convert-FromUnixdate ($unixDate) {
   $utc = ([datetime]'1/1/1970').AddSeconds($unixDate)
   $utc.ToLocalTime()
}

function Convert-ToUnixdate ($datetime) {
   $utc = ([DateTime]$datetime).ToUniversalTime()
   $timespan = $utc - ([datetime]'1/1/1970')
   $timespan.TotalSeconds
}

function ConvertPst-FromUnixdate ($unixDate) {
   $utc = ([datetime]'1/1/1970').AddSeconds($unixDate)
   $pstInfo = [TimeZoneInfo]::FindSystemTimeZoneById("Pacific Standard Time")
   [TimeZoneInfo]::ConvertTimeFromUtc($utc, $pstInfo)
}

function ConvertPst-ToUnixdate ($datetime) {
   $pstInfo = [TimeZoneInfo]::FindSystemTimeZoneById("Pacific Standard Time")
   $utc = [TimeZoneInfo]::ConvertTimeToUtc([DateTime]$datetime, $pstInfo)
   $timespan = $utc - ([datetime]'1/1/1970')
   $timespan.TotalSeconds
}

function Convert-FromJsonNetDate ($date) {
   $utc = ([datetime]'1/1/1970').AddMilliseconds($date)
   $utc.ToLocalTime()
}

function Grep-AliasCommand($pattern)
{
    Get-Alias |? { $_.ReferencedCommand.Name.Contains($pattern) }
}

New-Alias python27 C:\Tools\python2\python.exe
New-Alias python36 C:\Python36\python.exe

function use-agent-env()
{
    C:\projects\agent\env\Scripts\activate.ps1
    $env:PYTHONPATH = "C:\projects\agent\src;C:\projects\agent-aloha\src;C:\projects\agent-beyond\src;C:\projects\agent-cloud-connect\src;C:\projects\agent-common\src;C:\projects\agent-doshii\src;C:\projects\agent-infogenesis\src;C:\projects\agent-micros3700\src;C:\projects\agent-northstar\src;C:\projects\agent-positouch\src;C:\projects\agent-squirrel\src;C:\projects\agent-virtual\src;C:\projects\debug-helpers\src;"
}

if (-not $(ps pageant -ErrorAction SilentlyContinue))
{
    Start-Job -ScriptBlock {
        $mtx = New-Object System.Threading.Mutex($false, "pageant")
        if ($mtx.WaitOne(.5))
        {
            pageant $(Resolve-Path ~\.ssh\id_rsa.ppk)
        }
    } | Out-Null
}

$env:GOPATH = "C:\projects\go"
$env:TERM='xterm' # http://stefano.salvatori.cl/blog/2017/12/08/how-to-fix-open_stackdumpfile-dumping-stack-trace-to-less-exe-stackdump-gitcygwin/

function Start-RaxHVTunnels
{
    Start-Job -Name "Tunnel - RAX: jlevitt-POSi641-20180103" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -host router.raxvm.pos-api.com -port 63281
    } | Out-Null

    Start-Job -Name "Tunnel - RAX: jlevitt_AlohaTS-Term-base_2018-04-04" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -host router.raxvm.pos-api.com -port 63523
    } | Out-Null

    Start-Job -Name "Tunnel - RAX: jlevitt_DinerWare_2017-08-30" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -host router.raxvm.pos-api.com -port 63396
    } | Out-Null

    Start-Job -Name "Tunnel - RAX: jlevitt_MicrosRES5_Scott_20170711" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -host router.raxvm.pos-api.com -port 63316
    } | Out-Null
}

function Stop-RaxHVTunnels
{
    Get-Job |? { $_.Name.Contains("Tunnel - RAX:") } | Remove-Job -Force
}

function Start-HaywardHVTunnels
{
    Start-Job -Name "Tunnel - Hayward: Hypervisor" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3388
    } | Out-Null
    Start-Job -Name "Tunnel - Hayward: QS BOH" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3387
    } | Out-Null
    Start-Job -Name "Tunnel - Hayward: QS Master terminal" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3386
    } | Out-Null
    Start-Job -Name "Tunnel - Hayward: TS BOH" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3385
    } | Out-Null
    Start-Job -Name "Tunnel - Hayward: TS Master terminal" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3384
    } | Out-Null
    Start-Job -Name "Tunnel - Hayward: Squirrel-Dev" -ScriptBlock {
        C:\Users\jlevitt\.raxvm\omniprox.exe -port 3383
    } | Out-Null
}

function Start-AwsLinuxTest1Tunnel
{
    Start-Job -Name "Tunnel - AwsLinuxTest1" -ScriptBlock {
        while ($true)
        {
            ssh -i C:\Users\jlevitt\.ssh\aws-linux-test1.pem ec2-user@ec2-52-14-31-241.us-east-2.compute.amazonaws.com
        }
    } | Out-Null
}

function Stop-AwsLinuxTest1Tunnel
{
    Get-Job -Name "Tunnel - AwsLinuxTest1" | Remove-Job -Force
}

function Start-MySqlTunnel
{
    Start-Job -Name "Tunnel - MySql" -ScriptBlock {
        while ($true)
        {
            ssh -N -L 3307:localhost:3306 jlevitt
        }
    } | Out-Null
}

function Stop-MySqlTunnel
{
    Get-Job -Name "Tunnel - MySql" | Remove-Job -Force
}

function Start-SftpTunnel
{
    Start-Job -Name "Tunnel - Sftp" -ScriptBlock {
        while ($true)
        {
            ssh -N -L 2020:jlevitt:22 jlevitt
        }
    } | Out-Null
}

function Stop-SftpTunnel
{
    Get-Job -Name "Tunnel - Sftp" | Remove-Job -Force
}

function Start-DinerwareTunnel
{
    Start-Job -Name "Tunnel - Dinerware" -ScriptBlock {
        while ($true)
        {
            ssh -4 -L22222:127.0.0.1:22222 jlevitt@jump.dev-va1.internal.pos-api.com
        }
    } | Out-Null
}

function Stop-DinerwareTunnel
{
    Get-Job -Name "Tunnel - Dinerware" | Remove-Job -Force
}

function Start-JlevittTunnel
{
    Start-Job -Name "Tunnel - Jlevitt" -ScriptBlock {
        while ($true)
        {
            ssh -M 2023:2024 jlevitt
        }
    } | Out-Null
}

function Stop-JlevittTunnel
{
    Get-Job -Name "Tunnel - Jlevitt" | Remove-Job -Force
}



function Get-DebugBuild
{
    "$([DateTime]::Today.ToString("yy.M.d")).$(Get-Random -Minimum 1 -Maximum 1000)"
}
