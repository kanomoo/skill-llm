[CmdletBinding()]
param (
    [string]$ProjectsRoot = "C:\Project",
    [switch]$SkipGitPush,
    [switch]$GlobalOnly
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host " Antigravity Universal Skills and Standards Installer " -ForegroundColor Cyan
Write-Host "=======================================================`n" -ForegroundColor Cyan

# Source paths (Self-contained: prefer local repo files, fallback to external repo)
$SourceRepo = if (Test-Path (Join-Path $PSScriptRoot ".agents\rules\pdf_document_standards.md")) {
    $PSScriptRoot
} elseif (Test-Path "C:\Project\python-data-structures-and-algorithms\.agents\rules\pdf_document_standards.md") {
    "C:\Project\python-data-structures-and-algorithms"
} else {
    $PSScriptRoot
}
$SourceRules = Join-Path $SourceRepo ".agents\rules\pdf_document_standards.md"
$SourceSkillAcademic = Join-Path $SourceRepo ".agents\skills\academic-project-report"
$SourceSkillPdf = Join-Path $SourceRepo ".agents\skills\pdf-worksheet-solver"
$SourceSkillSlide = Join-Path $SourceRepo ".agents\skills\slide-designer"
$SourceAgentsMd = Join-Path $SourceRepo "AGENTS.md"

# Validation
if (-not (Test-Path $SourceRules) -or -not (Test-Path $SourceSkillAcademic) -or -not (Test-Path $SourceSkillPdf) -or -not (Test-Path $SourceSkillSlide) -or -not (Test-Path $SourceAgentsMd)) {
    Write-Error "Source files missing in $SourceRepo. Please ensure source skills and rules exist."
    exit 1
}

# 1. Global Installation: ~/.gemini and ~/.agents
$UserHome = [System.Environment]::GetFolderPath('UserProfile')
$GlobalGeminiConfig = Join-Path $UserHome ".gemini\config"
$GlobalAgentsHome = Join-Path $UserHome ".agents"

Write-Host "[1/2] Installing Global Skills and Rules..." -ForegroundColor Yellow

$GlobalTargets = @(
    @{
        SkillsDir = Join-Path $GlobalGeminiConfig "skills"
        RulesDir  = Join-Path $GlobalGeminiConfig "rules"
        Name      = "Antigravity Global (~/.gemini/config)"
    },
    @{
        SkillsDir = Join-Path $GlobalAgentsHome "skills"
        RulesDir  = Join-Path $GlobalAgentsHome "rules"
        Name      = "Universal Agent Global (~/.agents)"
    }
)

foreach ($g in $GlobalTargets) {
    Write-Host "  -> Configuring $($g.Name)..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $g.SkillsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $g.RulesDir -Force | Out-Null

    # Copy rules
    Copy-Item $SourceRules (Join-Path $g.RulesDir "pdf_document_standards.md") -Force

    # Copy skills (excluding pycache)
    Copy-Item -Recurse $SourceSkillAcademic $g.SkillsDir -Force
    Copy-Item -Recurse $SourceSkillPdf $g.SkillsDir -Force
    Copy-Item -Recurse $SourceSkillSlide $g.SkillsDir -Force

    # Clean pycache in global skills
    Get-ChildItem -Path (Join-Path $g.SkillsDir "academic-project-report"), (Join-Path $g.SkillsDir "pdf-worksheet-solver"), (Join-Path $g.SkillsDir "slide-designer") -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    Get-ChildItem -Path (Join-Path $g.SkillsDir "academic-project-report"), (Join-Path $g.SkillsDir "pdf-worksheet-solver"), (Join-Path $g.SkillsDir "slide-designer") -Recurse -Filter "*.pyc" -ErrorAction SilentlyContinue | Remove-Item -Force
}

Write-Host "  Global skills and rules successfully updated!`n" -ForegroundColor Green

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

    # Setup .agents/rules and .agents/skills
    $targetRulesDir = Join-Path $projPath ".agents\rules"
    $targetSkillsDir = Join-Path $projPath ".agents\skills"
    $targetAgentsMd = Join-Path $projPath "AGENTS.md"

    New-Item -ItemType Directory -Path $targetRulesDir -Force | Out-Null
    New-Item -ItemType Directory -Path $targetSkillsDir -Force | Out-Null

    # Copy rules and skills
    Copy-Item $SourceRules (Join-Path $targetRulesDir "pdf_document_standards.md") -Force
    Copy-Item -Recurse $SourceSkillAcademic $targetSkillsDir -Force
    Copy-Item -Recurse $SourceSkillPdf $targetSkillsDir -Force
    Copy-Item -Recurse $SourceSkillSlide $targetSkillsDir -Force
    Copy-Item $SourceAgentsMd $targetAgentsMd -Force

    # Clean pycache
    Get-ChildItem -Path (Join-Path $targetSkillsDir "academic-project-report"), (Join-Path $targetSkillsDir "pdf-worksheet-solver"), (Join-Path $targetSkillsDir "slide-designer") -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    Get-ChildItem -Path (Join-Path $targetSkillsDir "academic-project-report"), (Join-Path $targetSkillsDir "pdf-worksheet-solver"), (Join-Path $targetSkillsDir "slide-designer") -Recurse -Filter "*.pyc" -ErrorAction SilentlyContinue | Remove-Item -Force

    # Git handling
    if ($isGit) {
        $status = git -C $projPath status --porcelain
        if ($status) {
            Write-Host "    -> Changes detected in git repo. Staging and committing..." -ForegroundColor Gray
            git -C $projPath add AGENTS.md .agents
            git -C $projPath commit -m "feat(agents): update universal skills (academic-project-report, slide-designer, pdf-worksheet-solver) and standards" --quiet

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
Write-Host " ALL PROJECTS AND GLOBAL SKILLS FULLY SYNCHRONIZED! " -ForegroundColor Green
Write-Host "=======================================================`n" -ForegroundColor Cyan
