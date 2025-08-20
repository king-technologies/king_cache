@echo off
set CMD=%1

if "%CMD%"=="clean" (
  flutter clean
) else if "%CMD%"=="analyze" (
  flutter analyze
) else if "%CMD%"=="test" (
  flutter test
) else if "%CMD%"=="dry-run" (
  dart pub publish --dry-run
) else if "%CMD%"=="publish" (
  dart pub publish
) else if "%CMD%"=="help" (
  echo clean:         Clean the project
  echo analyze:       Analyze the project
  echo test:          Run tests
  echo dry-run:       Dry run
  echo publish:       Publish the package
) else (
  echo Unknown command: %CMD%
  echo Usage: commands [clean|analyze|test|dry-run|publish|help]
)
