$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Required = @(
  "pubspec.yaml",
  "lib\main.dart",
  "lib\src\app.dart",
  "integration\PALWAKF_MODULE_MANIFEST_V1.yaml"
)

foreach ($RelativePath in $Required) {
  $Path = Join-Path $Root $RelativePath
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "MISSING_CANONICAL_FILE=$RelativePath"
  }
}

if (Test-Path -LiteralPath (Join-Path $Root "workspace\pubspec.yaml")) {
  throw "NESTED_FLUTTER_PROJECT_DETECTED=workspace\pubspec.yaml"
}

$Main = Get-Content -LiteralPath (Join-Path $Root "lib\main.dart") -Raw -Encoding UTF8
if ($Main.Contains("Flutter Demo") -or $Main.Contains("MyHomePage")) {
  throw "DEFAULT_TEMPLATE_ENTRYPOINT_DETECTED"
}
if (-not $Main.Contains("EvidenceArchiveApp")) {
  throw "CANONICAL_APP_ENTRYPOINT_MISSING"
}

$Pubspec = Get-Content -LiteralPath (Join-Path $Root "pubspec.yaml") -Raw -Encoding UTF8
if (-not $Pubspec.Contains("flutter_riverpod:")) {
  throw "FLUTTER_RIVERPOD_DEPENDENCY_MISSING"
}

Write-Output "CANONICAL_RUNTIME_ROOT_GUARD=PASS"
Write-Output "CANONICAL_ENTRYPOINT=lib/main.dart"
Write-Output "NESTED_FLUTTER_PROJECT=ABSENT"
Write-Output "DEFAULT_TEMPLATE_ENTRYPOINT=ABSENT"
Write-Output "PLATFORM_MUTATION=NONE"
Write-Output "DATABASE_MUTATION=NONE"
