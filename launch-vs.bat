@echo off

REM === configuration ===
SET "ORIG_EXT_DIR=%USERPROFILE%\.vscode\extensions"

REM === get paths ===
set "SCRIPT_PATH=%~dp0"
set "SCRIPT_PATH=%SCRIPT_PATH:~0,-1%"
for %%A in ("%SCRIPT_PATH%") do (
    for %%B in ("%%~dpA") do set "HOME_DIR=%%~fB"
)
for %%A in ("%SCRIPT_PATH%") do set "WORKSPACE_NAME=%%~nxA"

SET "WORKSPACE_DIR=%HOME_DIR%\%WORKSPACE_NAME%"
SET "CUSTOM_EXT_DIR=%WORKSPACE_DIR%\extensions"
SET "WORKSPACE_FILE=%WORKSPACE_DIR%\%WORKSPACE_NAME%.code-workspace"
SET "VS_CODE_FOLDER=%WORKSPACE_DIR%\.vscode"

echo Home directory: "%HOME_DIR%"
echo Workspace: "%WORKSPACE_NAME%"

REM === Ensure workspace folder exists ===
IF NOT EXIST "%WORKSPACE_DIR%" (
    echo Workspace folder "%WORKSPACE_DIR%" does not exist.
    exit /b 1
)

REM === Ensure .vscode folder exists ===
IF NOT EXIST "%VS_CODE_FOLDER%" (
    echo .vscode folder "%VS_CODE_FOLDER%" does not exist.
    exit /b 1
)

REM === Clean and prepare custom extension dir ===
IF EXIST "%CUSTOM_EXT_DIR%" (
    rd /s /q "%CUSTOM_EXT_DIR%"
)
mkdir "%CUSTOM_EXT_DIR%"

REM === Create the .code-workspace file ===
(
    echo {
    echo   "folders": [
    echo     {
    echo       "path": "."
    echo     }
    echo   ],
    echo   "settings": {
    echo     "extensions.ignoreRecommendations": true
    echo   }
    echo }
) > "%WORKSPACE_FILE%"

REM === Create the .settings file ===
(
    echo  {
    echo    "C_Cpp.default.compilerPath": "C:/MinGW/bin/gcc.exe",
    echo    "C_Cpp.intelliSenseEngine": "default"
    echo  }
) > "%VS_CODE_FOLDER%\settings.json"

REM === Launch VS Code ===
pushd "%WORKSPACE_DIR%"
echo code --extensions-dir extensions --user-data-dir user-data --install-extension glenn2223.live-sass --disable-extension GitHub.copilot --force
call code --extensions-dir extensions --user-data-dir user-data --install-extension glenn2223.live-sass --disable-extension GitHub.copilot --force

REM === Create the .settings file ===
(
    echo  {
    echo      "extensions.allowed": {
    echo        "ms-vscode.cpptools": true,
    echo      },
    echo      "editor.fontSize": 14,
    echo      "editor.mouseWheelZoom": true,
    echo      "editor.formatOnType": true
    echo  }
) > "%WORKSPACE_DIR%\user-data\User\settings.json"

echo code --extensions-dir extensions --user-data-dir user-data "%WORKSPACE_NAME%.code-workspace" 
code --extensions-dir extensions --user-data-dir user-data "%WORKSPACE_NAME%.code-workspace" 
popd
