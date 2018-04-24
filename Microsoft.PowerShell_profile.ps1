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
   $utc = $datetime.ToUniversalTime()
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
            pageant.exe $HOME\.ssh\putty.ppk
        }
    } | Out-Null
}

$env:GOPATH = "C:\projects\go"
$env:TERM='xterm' # http://stefano.salvatori.cl/blog/2017/12/08/how-to-fix-open_stackdumpfile-dumping-stack-trace-to-less-exe-stackdump-gitcygwin/
