[CmdletBinding()]
param (
    [string]$ProjectsRoot = "C:\Project",
    [switch]$SkipGitPush,
    [switch]$GlobalOnly,
    [switch]$InstallPackages
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host " Antigravity Universal Skills, MCP & Rules Installer   " -ForegroundColor Cyan
Write-Host "=======================================================`n" -ForegroundColor Cyan

$SourceRepo = $PSScriptRoot
$SourceRulesDir = Join-Path $SourceRepo ".agents\rules"
$SourceSkillsDir = Join-Path $SourceRepo ".agents\skills"
$SourceMcpConfig = Join-Path $SourceRepo "mcp_config.json"
$SourceAgentsMd = Join-Path $SourceRepo "AGENTS.md"

# Validation
if (-not (Test-Path $SourceRulesDir) -or -not (Test-Path $SourceSkillsDir) -or -not (Test-Path $SourceAgentsMd)) {
    Write-Error "Source files missing in $SourceRepo. Please ensure source skills and rules exist."
    exit 1
}

# 0. Optional / Recommended: Package installation
if ($InstallPackages) {
    Write-Host "[0/3] Checking and Installing Required CLI and Python Packages..." -ForegroundColor Yellow
    
    # Python packages
    try {
        Write-Host "  -> Installing Python packages: litellm, browser-use, dspy, mem0ai, composio..." -ForegroundColor Gray
        pip install --upgrade litellm browser-use dspy mem0ai composio --quiet
        Write-Host "  Python packages successfully installed!" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to install Python packages: $_"
    }

    # NPM packages
    try {
        Write-Host "  -> Installing global NPM packages: repomix, @composio/core..." -ForegroundColor Gray
        npm install -g repomix @composio/core --quiet
        Write-Host "  NPM packages successfully installed!" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to install NPM packages: $_"
    }
}

# 1. Global Installation: ~/.gemini and ~/.agents
$UserHome = [System.Environment]::GetFolderPath('UserProfile')
$GlobalGeminiConfig = Join-Path $UserHome ".gemini\config"
$GlobalAgentsHome = Join-Path $UserHome ".agents"

Write-Host "[1/2] Installing Global Skills, MCP and Rules..." -ForegroundColor Yellow

$GlobalTargets = @(
    @{
        SkillsDir = Join-Path $GlobalGeminiConfig "skills"
        RulesDir  = Join-Path $GlobalGeminiConfig "rules"
        Name      = "Antigravity Global (~/.gemini/config)"
        IsGemini  = $true
    },
    @{
        SkillsDir = Join-Path $GlobalAgentsHome "skills"
        RulesDir  = Join-Path $GlobalAgentsHome "rules"
        Name      = "Universal Agent Global (~/.agents)"
        IsGemini  = $false
    }
)

foreach ($g in $GlobalTargets) {
    Write-Host "  -> Configuring $($g.Name)..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $g.SkillsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $g.RulesDir -Force | Out-Null

    # Copy all rules dynamically
    Get-ChildItem -Path $SourceRulesDir -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $g.RulesDir $_.Name) -Force
    }

    # Copy all skills dynamically
    Get-ChildItem -Path $SourceSkillsDir -Directory | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $g.SkillsDir -Recurse -Force
    }

    # Copy MCP configuration if Gemini
    if ($g.IsGemini -and (Test-Path $SourceMcpConfig)) {
        Copy-Item $SourceMcpConfig (Join-Path $GlobalGeminiConfig "mcp_config.json") -Force
        Write-Host "    -> Updated mcp_config.json in $($g.Name)" -ForegroundColor Gray
    }

    # Clean pycache in global skills
    Get-ChildItem -Path $g.SkillsDir -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    Get-ChildItem -Path $g.SkillsDir -Recurse -Filter "*.pyc" -ErrorAction SilentlyContinue | Remove-Item -Force
}

Write-Host "  Global skills, rules, and MCP configs successfully updated!`n" -ForegroundColor Green

if ($GlobalOnly) {
    Write-Host "GlobalOnly flag set. Finished!" -ForegroundColor Green
    exit 0
}

# 2. Project-level Deployment
Write-Host "[2/2] Scanning and Deploying to Projects in $ProjectsRoot..." -ForegroundColor Yellow

if (-not (Test-Path $ProjectsRoot)) {
    Write-Warning "Projects root directory not found: $ProjectsRoot"
    exit 0
}

$Projects = Get-ChildItem -Directory $ProjectsRoot | Sort-Object Name
$TotalProjects = $Projects.Count
$CurrentIndex = 0

foreach ($project in $Projects) {
    $CurrentIndex++
    $projPath = $project.FullName
    $projName = $project.Name
    $isGit = Test-Path (Join-Path $projPath ".git")

    # Skip self repo and external repos
    if ($projPath -eq $SourceRepo -or $projName -eq "Arch-Hyprland") {
        Write-Host "  [$CurrentIndex/$TotalProjects] Skipping '$projName'..." -ForegroundColor Cyan
        continue
    }

    Write-Host "  [$CurrentIndex/$TotalProjects] Processing '$projName'..." -ForegroundColor Cyan

    $targetRulesDir = Join-Path $projPath ".agents\rules"
    $targetSkillsDir = Join-Path $projPath ".agents\skills"
    $targetAgentsMd = Join-Path $projPath "AGENTS.md"

    New-Item -ItemType Directory -Path $targetRulesDir -Force | Out-Null
    New-Item -ItemType Directory -Path $targetSkillsDir -Force | Out-Null

    # Copy all rules dynamically
    Get-ChildItem -Path $SourceRulesDir -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $targetRulesDir $_.Name) -Force
    }

    # Copy all skills dynamically
    Get-ChildItem -Path $SourceSkillsDir -Directory | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $targetSkillsDir -Recurse -Force
    }

    Copy-Item $SourceAgentsMd $targetAgentsMd -Force

    # Clean pycache
    Get-ChildItem -Path $targetSkillsDir -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    Get-ChildItem -Path $targetSkillsDir -Recurse -Filter "*.pyc" -ErrorAction SilentlyContinue | Remove-Item -Force

    # Git handling
    if ($isGit) {
        $status = git -C $projPath status --porcelain -- AGENTS.md .agents
        if ($status) {
            Write-Host "    -> Changes detected in git repo. Staging and committing..." -ForegroundColor Gray
            git -C $projPath add AGENTS.md .agents
            git -C $projPath commit -m "feat(agents): update universal skills, rules, and effective agent principles" --quiet

            if (-not $SkipGitPush) {
                $branch = (git -C $projPath rev-parse --abbrev-ref HEAD).Trim()
                Write-Host "    -> Pushing to origin/$branch..." -ForegroundColor Gray
                $pushOutput = git -C $projPath push origin $branch 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "    Pushed to origin/$branch successfully!" -ForegroundColor Green
                } else {
                    Write-Warning "    Git push warning/error: $pushOutput"
                }
            } else {
                Write-Host "    Committed (push skipped)." -ForegroundColor Green
            }
        } else {
            Write-Host "    Up to date (no changes needed)." -ForegroundColor Green
        }
    } else {
        Write-Host "    Deployed (.agents and AGENTS.md installed, non-git folder)." -ForegroundColor Green
    }
}

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host " ALL PROJECTS, SKILLS, RULES & MCP FULLY SYNCHRONIZED! " -ForegroundColor Green
Write-Host "=======================================================`n" -ForegroundColor Cyan
