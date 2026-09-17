@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  AAxon Skill Runner (Windows 11)
REM  Skill:  spec-generation
REM  Phase:  01 - Establish Strategy
REM  Prompt: 15 (source: 01-establish-strategy.md)
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
set "SKILL_NAME=spec-generation"
set "SKILL_TITLE=Spec Generation"
set "SKILL_DIR=%ROOT_DIR%\skills_bundles\spec-generation"
set "PROMPT_FILE=%ROOT_DIR%\prompts\01-establish-strategy\15-spec-generation.txt"
set "REGISTRY_PATH=%ROOT_DIR%\registry\aa_skill_registry.json"
set "SESSION_NAME=aaxon-01-establish-strategy"

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
        --description "Synthesizes program knowledge into a complete Epics → Stories → Tasks specification in specs/spec.md and specs/tasks.md with all tasks scoped to 3 business days or fewer."
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
