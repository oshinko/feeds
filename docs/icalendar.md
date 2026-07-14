# iCalendar 作成ルール

`.ics` ファイルを作成・更新するときの共通ルールです。

## 文字コード

- `.ics` ファイルは UTF-8 で保存します。
- PowerShell で内容を確認する場合は、文字化けを避けるため UTF-8 を明示します。

```powershell
Get-Content .\calendars\earnings.ics -Encoding UTF8
```

## 日時

- 日時は必要に応じて `Asia/Tokyo` を明示します。
- 終日予定は `DTSTART;VALUE=DATE` / `DTEND;VALUE=DATE` を使います。
- `DTEND;VALUE=DATE` は終了日の翌日を指定します。
- 時刻未定の予定は終日予定として登録し、`SUMMARY` や `DESCRIPTION` に「時刻未定」と明記します。
- 予定時刻が推定の場合は、`SUMMARY` や `DESCRIPTION` に「目安」と明記します。

## UID

- UID はフィード内で一意にします。
- UID の末尾には `@feeds.osnk` を付けます。
- 時刻は変更される可能性があるため、UID には含めません。
- 既存イベントの時刻、説明、表記を変更する場合は、原則として UID を維持します。
- 予定を変更する場合は、対象イベントの `LAST-MODIFIED` と `SEQUENCE` も更新します。

## イベント例

```ics
BEGIN:VEVENT
UID:example-20260507@feeds.osnk
DTSTAMP:20260507T000000Z
LAST-MODIFIED:20260507T000000Z
SEQUENCE:1
DTSTART;TZID=Asia/Tokyo:20260507T153000
DTEND;TZID=Asia/Tokyo:20260507T160000
SUMMARY:イベント名
DESCRIPTION:イベントの説明
STATUS:CONFIRMED
TRANSP:TRANSPARENT
END:VEVENT
```
