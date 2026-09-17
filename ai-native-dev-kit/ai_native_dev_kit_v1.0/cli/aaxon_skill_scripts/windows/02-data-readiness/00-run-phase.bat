@echo off
setlocal

REM Runs all AAxon skill scripts for phase 02-data-readiness IN ORDER.
REM Each individual script handles its own idempotent registration.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo.
echo ##### Prompt 1: context-fabric #####
call "%SCRIPT_DIR%01-context-fabric.bat"
if errorlevel 1 (
    echo Stopping: 01-context-fabric.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 2: policy-catalog #####
call "%SCRIPT_DIR%02-policy-catalog.bat"
if errorlevel 1 (
    echo Stopping: 02-policy-catalog.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 3: research-copilot #####
call "%SCRIPT_DIR%03-research-copilot.bat"
if errorlevel 1 (
    echo Stopping: 03-research-copilot.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 4: assumption-tracker #####
call "%SCRIPT_DIR%04-assumption-tracker.bat"
if errorlevel 1 (
    echo Stopping: 04-assumption-tracker.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 5: transform-iq #####
call "%SCRIPT_DIR%05-transform-iq.bat"
if errorlevel 1 (
    echo Stopping: 05-transform-iq.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 6: spec-flow #####
call "%SCRIPT_DIR%06-spec-flow.bat"
if errorlevel 1 (
    echo Stopping: 06-spec-flow.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 7: trace-graph #####
call "%SCRIPT_DIR%07-trace-graph.bat"
if errorlevel 1 (
    echo Stopping: 07-trace-graph.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 8: spec-impact-analyzer #####
call "%SCRIPT_DIR%08-spec-impact-analyzer.bat"
if errorlevel 1 (
    echo Stopping: 08-spec-impact-analyzer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 9: value-modeler #####
call "%SCRIPT_DIR%09-value-modeler.bat"
if errorlevel 1 (
    echo Stopping: 09-value-modeler.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 10: portfolio-prioritizer #####
call "%SCRIPT_DIR%10-portfolio-prioritizer.bat"
if errorlevel 1 (
    echo Stopping: 10-portfolio-prioritizer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 11: scenario-planner #####
call "%SCRIPT_DIR%11-scenario-planner.bat"
if errorlevel 1 (
    echo Stopping: 11-scenario-planner.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 12: decision-ledger #####
call "%SCRIPT_DIR%12-decision-ledger.bat"
if errorlevel 1 (
    echo Stopping: 12-decision-ledger.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 13: conductor #####
call "%SCRIPT_DIR%13-conductor.bat"
if errorlevel 1 (
    echo Stopping: 13-conductor.bat failed.
    exit /b 1
)

echo Phase 02-data-readiness complete.
endlocal
