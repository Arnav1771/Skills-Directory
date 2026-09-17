@echo off
setlocal

REM Runs all AAxon skill scripts for phase 04-ai-solution-deployment IN ORDER.
REM Each individual script handles its own idempotent registration.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo.
echo ##### Prompt 1: release-intel #####
call "%SCRIPT_DIR%01-release-intel.bat"
if errorlevel 1 (
    echo Stopping: 01-release-intel.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 2: parity-checker #####
call "%SCRIPT_DIR%02-parity-checker.bat"
if errorlevel 1 (
    echo Stopping: 02-parity-checker.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 3: rollout-advisor #####
call "%SCRIPT_DIR%03-rollout-advisor.bat"
if errorlevel 1 (
    echo Stopping: 03-rollout-advisor.bat failed.
    exit /b 1
)

echo Phase 04-ai-solution-deployment complete.
endlocal
