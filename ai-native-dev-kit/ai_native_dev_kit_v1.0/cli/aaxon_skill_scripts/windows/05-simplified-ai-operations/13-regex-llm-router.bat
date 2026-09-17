@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  AAxon Skill Runner (Windows 11)
REM  Skill:  regex-llm-router
REM  Phase:  05 - Simplified AI Operations
REM  Prompt: 13 (source: 05-simplified-ai-operations.md)
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
set "SKILL_NAME=regex-llm-router"
set "SKILL_TITLE=Regex Llm Router"
set "SKILL_DIR=%ROOT_DIR%\skills_bundles\regex-llm-router"
set "PROMPT_FILE=%ROOT_DIR%\prompts\05-simplified-ai-operations\13-regex-llm-router.txt"
set "REGISTRY_PATH=%ROOT_DIR%\registry\aa_skill_registry.json"
set "SESSION_NAME=aaxon-05-simplified-ai-operations"

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
        --description "RegexLLMRouter eliminates wasteful LLM spend on tasks solvable in code. For every parsing task, it scores structural regularity and routes to deterministic regex (cost ~$0), hybrid (regex with LLM fallback), or full LLM. Pre-scored taxonomy handles common customer-service patterns."
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
