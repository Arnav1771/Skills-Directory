@echo off
setlocal

REM Runs all AAxon skill scripts for phase 03-platform-enablement IN ORDER.
REM Each individual script handles its own idempotent registration.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo.
echo ##### Prompt 1: knowledge-mesh #####
call "%SCRIPT_DIR%01-knowledge-mesh.bat"
if errorlevel 1 (
    echo Stopping: 01-knowledge-mesh.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 2: secret-shield #####
call "%SCRIPT_DIR%02-secret-shield.bat"
if errorlevel 1 (
    echo Stopping: 02-secret-shield.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 3: trust-fabric #####
call "%SCRIPT_DIR%03-trust-fabric.bat"
if errorlevel 1 (
    echo Stopping: 03-trust-fabric.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 4: performance-optimizer #####
call "%SCRIPT_DIR%04-performance-optimizer.bat"
if errorlevel 1 (
    echo Stopping: 04-performance-optimizer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 5: experience-studio #####
call "%SCRIPT_DIR%05-experience-studio.bat"
if errorlevel 1 (
    echo Stopping: 05-experience-studio.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 6: dev-copilot #####
call "%SCRIPT_DIR%06-dev-copilot.bat"
if errorlevel 1 (
    echo Stopping: 06-dev-copilot.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 7: prompt-bench #####
call "%SCRIPT_DIR%07-prompt-bench.bat"
if errorlevel 1 (
    echo Stopping: 07-prompt-bench.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 8: review-pilot #####
call "%SCRIPT_DIR%08-review-pilot.bat"
if errorlevel 1 (
    echo Stopping: 08-review-pilot.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 9: nexus-deploy #####
call "%SCRIPT_DIR%09-nexus-deploy.bat"
if errorlevel 1 (
    echo Stopping: 09-nexus-deploy.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 10: guardian #####
call "%SCRIPT_DIR%10-guardian.bat"
if errorlevel 1 (
    echo Stopping: 10-guardian.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 11: eval-harness #####
call "%SCRIPT_DIR%11-eval-harness.bat"
if errorlevel 1 (
    echo Stopping: 11-eval-harness.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 12: red-team-x #####
call "%SCRIPT_DIR%12-red-team-x.bat"
if errorlevel 1 (
    echo Stopping: 12-red-team-x.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 13: sim-lab #####
call "%SCRIPT_DIR%13-sim-lab.bat"
if errorlevel 1 (
    echo Stopping: 13-sim-lab.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 14: policy-enforcer #####
call "%SCRIPT_DIR%14-policy-enforcer.bat"
if errorlevel 1 (
    echo Stopping: 14-policy-enforcer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 15: insight-ops #####
call "%SCRIPT_DIR%15-insight-ops.bat"
if errorlevel 1 (
    echo Stopping: 15-insight-ops.bat failed.
    exit /b 1
)

echo Phase 03-platform-enablement complete.
endlocal
