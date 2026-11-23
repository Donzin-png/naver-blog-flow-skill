# naver-blog-flow-skill

네이버 블로그 레퍼런스를 바탕으로 한국어 원고를 쓰고, Google Flow로 시공/과정 이미지를 만들어, 업체 홍보 톤이 섞인 마크다운 파일로 완성하는 에이전트 스킬입니다.

## 설치

```bash
npx skills add Donzin-png/naver-blog-flow-skill
```

미리 보기:

```bash
npx skills add Donzin-png/naver-blog-flow-skill --list
```

전역 설치(모든 프로젝트에서 사용):

```bash
npx skills add Donzin-png/naver-blog-flow-skill --skill naver-blog-flow-skill -g -y
```

OpenCode만 지정하려면:

```bash
npx skills add Donzin-png/naver-blog-flow-skill --skill naver-blog-flow-skill -a opencode -y
```

## 사용 예

```
https://m.blog.naver.com/... 레퍼런스 보고 9mm 문선 블로그 글 써줘.
시공방식은 Google Flow 이미지로 넣고, 2D 탑뷰 비교 그림도 추가해줘.
업체는 동진(DONG-ZIN), 부산 번호 넣어서 홍보 톤으로 마무리해줘.
```

## 포함된 것

- `SKILL.md` — 전체 워크플로와 하드 룰
- `references/workflow.md` — Orca CLI 명령, Flow 다운로드 함정
- `references/prompts.md` — 복붙용 Flow 프롬프트
- `references/example-9mm.md` — 완성 예시 원고(전화번호는 데모용)
- `scripts/inspect-images.ps1` — 이미지 확장자/매직바이트 검사

## 주의

- Google Flow 사용에는 로그인된 브라우저 세션이 필요합니다. 이 스킬은 자격증명을 요구하거나 저장하지 않습니다.
- 공개 게시는 사용자 승인을 받기 전 하지 않습니다.
- 예시 원고의 전화번호는 임의 번호입니다. 실제 배포 전 교체하세요.

## 라이선스

MIT
