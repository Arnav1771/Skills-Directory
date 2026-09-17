@echo off
setlocal

REM Runs every AAxon phase end-to-end, in order.
REM This will take a long time and consume real API credit - review
REM aa-skills credits show between phases if you're budget-conscious.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo ===== Phase: 01-establish-strategy =====
call "%SCRIPT_DIR%01-establish-strategy\00-run-phase.bat"
if errorlevel 1 exit /b 1

echo ===== Phase: 02-data-readiness =====
call "%SCRIPT_DIR%02-data-readiness\00-run-phase.bat"
if errorlevel 1 exit /b 1

echo ===== Phase: 03-platform-enablement =====
call "%SCRIPT_DIR%03-platform-enablement\00-run-phase.bat"
if errorlevel 1 exit /b 1

echo ===== Phase: 04-ai-solution-deployment =====
call "%SCRIPT_DIR%04-ai-solution-deployment\00-run-phase.bat"
if errorlevel 1 exit /b 1

echo ===== Phase: 05-simplified-ai-operations =====
call "%SCRIPT_DIR%05-simplified-ai-operations\00-run-phase.bat"
if errorlevel 1 exit /b 1

echo All phases complete.
endlocal
