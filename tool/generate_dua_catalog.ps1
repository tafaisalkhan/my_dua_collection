$ErrorActionPreference = 'Stop'
$source = Get-Content -Raw 'assets\data\hisnul_muslim_source.json' | ConvertFrom-Json
$all = @(foreach ($seg in $source.segments) {
  foreach ($cat in $seg.categories) {
    foreach ($title in $cat.titles) {
      foreach ($dua in $title.duas) {
        if (-not [string]::IsNullOrWhiteSpace([string]$dua.arabic) -and -not [string]::IsNullOrWhiteSpace([string]$dua.translation)) {
          [pscustomobject]@{ Segment=[string]$seg.segment_name; SourceCategory=[string]$cat.category_name; SourceTitle=[string]$title.title_name; Dua=$dua }
        }
      }
    }
  }
})
function Get-Candidates([string]$name) {
  switch ($name) {
    'Morning' { @($all | Where-Object SourceTitle -eq 'Morning Remembrance') }
    'Evening' { @($all | Where-Object SourceTitle -eq 'Evening Remembrance') }
    'Night' { @($all | Where-Object { $_.SourceCategory -eq 'Waking & Sleeping' -or $_.SourceTitle -eq 'Evening Remembrance' }) }
    'Before Sleep' { @($all | Where-Object { $_.SourceTitle -match 'Sleeping|sleeping|wake up|night approaches' -or $_.SourceTitle -eq 'Evening Remembrance' }) }
    'After Prayer' { @($all | Where-Object { $_.SourceCategory -in @('After Prayer','Masjid','Adhan & Iqamah') }) }
    'Protection' { @($all | Where-Object { $_.SourceCategory -in @('Protection',"Seeking Allah's Protection") }) }
    'Travel' { @($all | Where-Object SourceCategory -eq 'Home & Travel') }
    'Forgiveness' { @($all | Where-Object { $_.SourceCategory -in @('Seeking Forgiveness','Forgiveness & Repentance') }) }
    'Family' { @($all | Where-Object { $_.SourceCategory -in @('Family & Righteous Offspring','Family & Children') }) }
    'Health' { @($all | Where-Object SourceCategory -eq 'Health & Sickness') }
    'Rizq' { @($all | Where-Object { $_.SourceCategory -in @('Daily Needs','Success & Rizq') -or $_.SourceTitle -match 'Rizq|need|debt|success' }) }
    "Qur'anic Dua" { @($all | Where-Object Segment -eq 'Quranic Duas') }
    'Personal' { @($all | Where-Object { $_.SourceCategory -in @('Hardship & Patience','Guidance & Decisions','Knowledge & Wisdom') }) }
  }
}
$categories = @('Morning','Evening','Night','Before Sleep','After Prayer','Protection','Travel','Forgiveness','Family','Health','Rizq',"Qur'anic Dua",'Personal')
$out = [Collections.Generic.List[object]]::new()
foreach ($category in $categories) {
  $seen = @{}
  $chosen = [Collections.Generic.List[object]]::new()
  foreach ($entry in (Get-Candidates $category)) {
    $key = ([string]$entry.Dua.arabic).Trim()
    if (-not $seen.ContainsKey($key)) { $seen[$key] = $true; $chosen.Add($entry) }
    if ($chosen.Count -eq 10) { break }
  }
  if ($chosen.Count -lt 10) { throw "$category has only $($chosen.Count) mapped entries" }
  for ($i=0; $i -lt 10; $i++) {
    $entry = $chosen[$i]; $dua = $entry.Dua
    $slug = ($category.ToLowerInvariant() -replace '[^a-z0-9]+','-').Trim('-')
    $out.Add([ordered]@{
      id=('famous-{0}-{1:d2}' -f $slug,($i+1)); category=$category
      title=[ordered]@{en=[string]$entry.SourceTitle}; arabic=([string]$dua.arabic).Trim()
      transliteration=([string]$dua.latin).Trim(); translations=[ordered]@{en=([string]$dua.translation).Trim()}
      reference=([string]$dua.source).Trim(); sourceCollection='Hisnul Muslim'; sourceCategory=[string]$entry.SourceCategory
    })
  }
}
$root = [ordered]@{version=3; defaultLocale='en'; supportedLocales=@('ar','en'); translationSchema='Add another language by adding its ISO language code inside each translations object.'; sourceAttribution='Hisnul Muslim dataset prepared by Sehal Hussain for Kitably; source references retained per entry.'; duas=$out}
$json = $root | ConvertTo-Json -Depth 8
$check = $json | ConvertFrom-Json
if ($check.duas.Count -ne 130) { throw "Expected 130 entries, got $($check.duas.Count)" }
[IO.File]::WriteAllText('assets\data\builtin_duas.json',$json)
$check.duas | Group-Object category | Select-Object Name,Count