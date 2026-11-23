# Google Flow 이미지 생성 실무 (Orca CLI)

이 문서는 실제로 동작했던 명령 순서를 정리한 것이다. 화면의 `ref` 값은 매번 바뀌므로 **클릭·입력 전에 항상 `snapshot`을 다시 실행**해 현재 값을 읽는다.

## 0. Orca CLI 경로

이 환경에서는 아래 경로였다. 다른 환경이면 `orca-cli` 스킬이나 `where orca`로 경로를 찾는다.

```powershell
$exe = 'C:\Users\User\AppData\Local\Programs\orca\resources\bin\orca.exe'
```

## 1. Flow 탭 찾기

```powershell
& $exe tab list --json
```

로그인된 `https://flow.google.com/project/...` 탭의 `browserPageId`를 찾는다. 없으면 사용자가 직접 로그인하도록 안내한다. 자격증명을 받거나 저장하지 않는다.

## 2. 현재 화면 읽기

```powershell
& $exe snapshot --page <pageId> --interactive
```

프로젝트 화면에서 이런 항목이 보인다.

- `textbox "무엇을 만들고 싶으신가요?"` — 프롬프트 입력창
- `button "생성 시작"` — 생성 버튼
- `button "미디어 메뉴 추가"` — 새 이미지 생성

## 3. 프롬프트 입력과 생성

```powershell
& $exe fill --page <pageId> --element <프롬프트ref> --value '<프롬프트 문장>' --json
& $exe click --page <pageId> --element <생성ref> --json
```

한국어 프롬프트는 PowerShell에서 작은따옴표로 감싸면 그대로 전달된다. 프롬프트는 `references/prompts.md` 참고.

## 4. 생성 끝까지 기다리기

진행률이 화면에 퍼센트로 나오므로, 더 이상 퍼센트가 없을 때까지 읽는다.

```powershell
for ($i = 0; $i -lt 36; $i++) {
  Start-Sleep -Seconds 5
  $out = & $exe exec --page <pageId> --command read --json | Out-String
  if ($out -notmatch '\d+%') { Write-Output "done after $($i+1) checks"; break }
}
& $exe snapshot --page <pageId> --interactive
```

## 5. 이미지 저장 (중요)

**목록 화면의 이미지 요소를 직접 다운로드하면 `browser_download_not_started`로 실패할 수 있다.** 아래 경로를 쓴다.

1. `snapshot`에서 새로 생성된 이미지 버튼을 찾아 클릭해 상세 화면으로 들어간다.

```powershell
& $exe click --page <pageId> --element <이미지ref> --json
```

2. 상세 화면에서 `button "미디어 다운로드"`를 클릭한다.
3. 펼쳐진 메뉴에서 **1K 원본 크기** 항목의 ref를 확인한다.
4. 그 ref를 `--selector`로 넣어 저장한다.

```powershell
& $exe click --page <pageId> --element <다운로드메뉴ref> --json
& $exe download --page <pageId> --selector <1K원본ref> --path 'd:\...\9mm-문선-04-비교단면.jpg' --json
```

5. 상세 화면에서 나갈 때는 `button "수정 완료"`를 클릭한다.

파일명은 `주제-번호-설명.jpg` 형태로 붙이면 순서가 명확하다. 예)

- `9mm-문선-01-철거.jpg`
- `9mm-문선-02-시공.jpg`
- `9mm-문선-03-완성.jpg`
- `9mm-문선-04-비교단면.jpg`
- `9mm-문선-05-시공순서탑뷰.jpg`

## 6. 저장 후 포맷 검사

Flow가 `.png` 확장자로 내려주지만 파일 앞 4바이트가 `FF-D8-FF-E0`(JPEG)인 경우가 있었다. 그대로 두면 블로그 업로드에서 문제가 될 수 있으므로 검사한다.

```powershell
& powershell -File scripts/inspect-images.ps1 -Path '9mm-문선-01-철거.jpg','9mm-문선-02-시공.jpg'
```

`RENAME_TO_JPG`가 나오면 실제 확장자로 바꾸고 원고의 이미지 링크도 함께 수정한다.

```powershell
Rename-Item -LiteralPath '9mm-문선-01-철거.png' -NewName '9mm-문선-01-철거.jpg'
```

## 7. 자주 겪는 실수

- **ref 재사용**: 이전 스냅샷의 ref를 그대로 쓰면 엉뚱한 버튼이 눌린다. 매 단계 재스냅샷.
- **퍼센트 루프 조기 종료**: 로그에 남은 다른 숫자 때문에 타이밍을 놓치면, 스냅샷에서 생성 결과가 보이는지 최종 확인한다.
- **이미지 내용 검증 불가**: 모델이 이미지를 못 보면 프롬프트와 파일 용량으로만 확인했다고 밝힌다. 사용자에게 육안 확인을 요청할 수 있다.
