@echo off
setlocal

REM Runs all AAxon skill scripts for phase 05-simplified-ai-operations IN ORDER.
REM Each individual script handles its own idempotent registration.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo.
echo ##### Prompt 1: control-plane #####
call "%SCRIPT_DIR%01-control-plane.bat"
if errorlevel 1 (
    echo Stopping: 01-control-plane.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 2: runtime-iq #####
call "%SCRIPT_DIR%02-runtime-iq.bat"
if errorlevel 1 (
    echo Stopping: 02-runtime-iq.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 3: drift-guard #####
call "%SCRIPT_DIR%03-drift-guard.bat"
if errorlevel 1 (
    echo Stopping: 03-drift-guard.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 4: incident-lens #####
call "%SCRIPT_DIR%04-incident-lens.bat"
if errorlevel 1 (
    echo Stopping: 04-incident-lens.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 5: runbook-synth #####
call "%SCRIPT_DIR%05-runbook-synth.bat"
if errorlevel 1 (
    echo Stopping: 05-runbook-synth.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 6: value-tracker #####
call "%SCRIPT_DIR%06-value-tracker.bat"
if errorlevel 1 (
    echo Stopping: 06-value-tracker.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 7: experiment-ops #####
call "%SCRIPT_DIR%07-experiment-ops.bat"
if errorlevel 1 (
    echo Stopping: 07-experiment-ops.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 8: tool-surface-auditor #####
call "%SCRIPT_DIR%08-tool-surface-auditor.bat"
if errorlevel 1 (
    echo Stopping: 08-tool-surface-auditor.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 9: prompt-slimmer #####
call "%SCRIPT_DIR%09-prompt-slimmer.bat"
if errorlevel 1 (
    echo Stopping: 09-prompt-slimmer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 10: budget-governor #####
call "%SCRIPT_DIR%10-budget-governor.bat"
if errorlevel 1 (
    echo Stopping: 10-budget-governor.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 11: semantic-cache #####
call "%SCRIPT_DIR%11-semantic-cache.bat"
if errorlevel 1 (
    echo Stopping: 11-semantic-cache.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 12: model-router #####
call "%SCRIPT_DIR%12-model-router.bat"
if errorlevel 1 (
    echo Stopping: 12-model-router.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 13: regex-llm-router #####
call "%SCRIPT_DIR%13-regex-llm-router.bat"
if errorlevel 1 (
    echo Stopping: 13-regex-llm-router.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 14: context-profiler #####
call "%SCRIPT_DIR%14-context-profiler.bat"
if errorlevel 1 (
    echo Stopping: 14-context-profiler.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 15: relevance-pruner #####
call "%SCRIPT_DIR%15-relevance-pruner.bat"
if errorlevel 1 (
    echo Stopping: 15-relevance-pruner.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 16: rolling-summarizer #####
call "%SCRIPT_DIR%16-rolling-summarizer.bat"
if errorlevel 1 (
    echo Stopping: 16-rolling-summarizer.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 17: strategic-compactor #####
call "%SCRIPT_DIR%17-strategic-compactor.bat"
if errorlevel 1 (
    echo Stopping: 17-strategic-compactor.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 18: iterative-retrieval #####
call "%SCRIPT_DIR%18-iterative-retrieval.bat"
if errorlevel 1 (
    echo Stopping: 18-iterative-retrieval.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 19: memory-persistence #####
call "%SCRIPT_DIR%19-memory-persistence.bat"
if errorlevel 1 (
    echo Stopping: 19-memory-persistence.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 20: eval-harness #####
call "%SCRIPT_DIR%20-eval-harness.bat"
if errorlevel 1 (
    echo Stopping: 20-eval-harness.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 21: pattern-extractor #####
call "%SCRIPT_DIR%21-pattern-extractor.bat"
if errorlevel 1 (
    echo Stopping: 21-pattern-extractor.bat failed.
    exit /b 1
)

echo Phase 05-simplified-ai-operations complete.
endlocal
