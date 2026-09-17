@echo off
setlocal

REM Runs all AAxon skill scripts for phase 01-establish-strategy IN ORDER.
REM Each individual script handles its own idempotent registration.

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY is not set.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"

echo.
echo ##### Prompt 1: program-charter #####
call "%SCRIPT_DIR%01-program-charter.bat"
if errorlevel 1 (
    echo Stopping: 01-program-charter.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 2: spec-knowledge #####
call "%SCRIPT_DIR%02-spec-knowledge.bat"
if errorlevel 1 (
    echo Stopping: 02-spec-knowledge.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 3: spec-design #####
call "%SCRIPT_DIR%03-spec-design.bat"
if errorlevel 1 (
    echo Stopping: 03-spec-design.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 4: spec-uiux #####
call "%SCRIPT_DIR%04-spec-uiux.bat"
if errorlevel 1 (
    echo Stopping: 04-spec-uiux.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 5: spec-database #####
call "%SCRIPT_DIR%05-spec-database.bat"
if errorlevel 1 (
    echo Stopping: 05-spec-database.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 6: spec-api #####
call "%SCRIPT_DIR%06-spec-api.bat"
if errorlevel 1 (
    echo Stopping: 06-spec-api.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 7: skill-flow #####
call "%SCRIPT_DIR%07-skill-flow.bat"
if errorlevel 1 (
    echo Stopping: 07-skill-flow.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 8: skill-generator #####
call "%SCRIPT_DIR%08-skill-generator.bat"
if errorlevel 1 (
    echo Stopping: 08-skill-generator.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 9: requirements-elicitation-charter #####
call "%SCRIPT_DIR%09-requirements-elicitation-charter.bat"
if errorlevel 1 (
    echo Stopping: 09-requirements-elicitation-charter.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 10: doc-extraction #####
call "%SCRIPT_DIR%10-doc-extraction.bat"
if errorlevel 1 (
    echo Stopping: 10-doc-extraction.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 11: code-extraction #####
call "%SCRIPT_DIR%11-code-extraction.bat"
if errorlevel 1 (
    echo Stopping: 11-code-extraction.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 12: meeting-extraction #####
call "%SCRIPT_DIR%12-meeting-extraction.bat"
if errorlevel 1 (
    echo Stopping: 12-meeting-extraction.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 13: knowledge-review #####
call "%SCRIPT_DIR%13-knowledge-review.bat"
if errorlevel 1 (
    echo Stopping: 13-knowledge-review.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 14: design-setup #####
call "%SCRIPT_DIR%14-design-setup.bat"
if errorlevel 1 (
    echo Stopping: 14-design-setup.bat failed.
    exit /b 1
)
echo.
echo ##### Prompt 15: spec-generation #####
call "%SCRIPT_DIR%15-spec-generation.bat"
if errorlevel 1 (
    echo Stopping: 15-spec-generation.bat failed.
    exit /b 1
)

echo Phase 01-establish-strategy complete.
endlocal
