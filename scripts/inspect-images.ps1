param(
  [Parameter(Mandatory = $true)]
  [string[]] $Path
)

foreach ($p in $Path) {
  if (-not (Test-Path -LiteralPath $p)) {
    Write-Output "MISSING`tUNKNOWN`tUNKNOWN`t$p"
    continue
  }

  $bytes = [System.IO.File]::ReadAllBytes($p)
  $len = [Math]::Min(8, $bytes.Length)
  $sig = [BitConverter]::ToString($bytes, 0, $len)

  $kind = 'UNKNOWN'
  if ($sig -like 'FF-D8-FF-*') { $kind = 'JPEG' }
  elseif ($sig -like '89-50-4E-47-*') { $kind = 'PNG' }

  $ext = [System.IO.Path]::GetExtension($p).TrimStart('.').ToUpperInvariant()
  if ([string]::IsNullOrEmpty($ext)) { $ext = '(none)' }

  $verdict = 'OK'
  if ($kind -ne 'UNKNOWN' -and $kind -ne $ext) {
    $verdict = "RENAME_TO_$($kind.ToLowerInvariant())"
  }

  $kb = [Math]::Round($bytes.Length / 1KB, 1)
  Write-Output "$kind`t$ext`t$verdict`t$kb KB`t$p"
}
