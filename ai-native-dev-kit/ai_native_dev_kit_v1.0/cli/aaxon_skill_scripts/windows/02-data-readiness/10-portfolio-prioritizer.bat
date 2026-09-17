@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  AAxon Skill Runner (Windows 11)
REM  Skill:  portfolio-prioritizer
REM  Phase:  02 - Data Readiness
REM  Prompt: 10 (source: 02-data-readiness.md)
REM  First registration point for this skill.
REM ============================================================

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    echo   Set it first, e.g.:  set ANTHROPIC_API_KEY=sk-ant-...
    exit /b 1
)

REM Resolve paths relative to this script's location, regardless of cwd.
set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%..\.."
set "SKILL_NAME=portfolio-prioritizer"
set "SKILL_TITLE=Portfolio Prioritizer"
set "SKILL_DIR=%ROOT_DIR%\skills_bundles\portfolio-prioritizer"
set "PROMPT_FILE=%ROOT_DIR%\prompts\02-data-readiness\10-portfolio-prioritizer.txt"
set "REGISTRY_PATH=%ROOT_DIR%\registry\aa_skill_registry.json"
set "SESSION_NAME=aaxon-02-data-readiness"

if not exist "%PROMPT_FILE%" (
    echo ERROR: Prompt file not found: %PROMPT_FILE%
    exit /b 1
)

echo === [%SKILL_NAME%] Checking whether the skill is already registered ===
aa-skills --registry "%REGISTRY_PATH%" list-skills | findstr /I /C:"%SKILL_NAME% " >nul
if %ERRORLEVEL%==0 (
    echo Skill "%SKILL_NAME%" is already registered in %REGISTRY_PATH% - skipping registration.
) else (
    echo Registering skill "%SKILL_NAME%" from %SKILL_DIR% ...
    aa-skills --registry "%REGISTRY_PATH%" register-skill ^
        --dir "%SKILL_DIR%" ^
        --name "%SKILL_NAME%" ^
        --title "%SKILL_TITLE%" ^
        --description "Ranks all sprint backlog candidates using weighted composite scoring and draws a capacity cut line, producing a PROCEED/DEFERRED/BORDERLINE ranked scope list with defer rationale."
    if errorlevel 1 (
        echo Registration failed for "%SKILL_NAME%". Aborting.
        exit /b 1
    )
)

echo === [%SKILL_NAME%] Invoking with prompt: %PROMPT_FILE% ===
aa-skills --registry "%REGISTRY_PATH%" invoke ^
    --skills %SKILL_NAME% ^
    --prompt-file "%PROMPT_FILE%" ^
    --session "%SESSION_NAME%"
if errorlevel 1 (
    echo Invocation failed for "%SKILL_NAME%".
    exit /b 1
)

echo === [%SKILL_NAME%] Done ===
endlocal
