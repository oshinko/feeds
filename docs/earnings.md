# 決算フィード

`calendars/earnings.ics` は、対象銘柄の決算予定を管理する iCalendar フィードです。

## 購読 URL

```text
https://raw.githubusercontent.com/oshinko/feeds/main/calendars/earnings.ics
```

## 管理対象

| 証券コード | 銘柄名 | UID の接頭辞 |
| --- | --- | --- |
| 8306 | 三菱UFJフィナンシャル・グループ | `earnings-8306-` |
| 4063 | 信越化学工業 | `earnings-4063-` |
| 3436 | SUMCO | `earnings-3436-` |
| 4004 | レゾナックHD | `earnings-4004-` |
| 6963 | ローム | `earnings-6963-` |
| 6890 | フェローテック | `earnings-6890-` |
| 6525 | KOKUSAI ELECTRIC | `earnings-6525-` |
| 5803 | フジクラ | `earnings-5803-` |
| 5016 | JX金属 | `earnings-5016-` |
| 1812 | 鹿島建設 | `earnings-1812-` |
| 2914 | JT | `earnings-2914-` |
| 1605 | INPEX | `earnings-1605-` |
| 8006 | ユアサ・フナショク | `earnings-8006-` |

## 更新手順

共通の `.ics` 作成・更新ルールは [iCalendar 作成ルール](icalendar.md) を参照します。

既存イベントを更新する場合は、証券コードまたは `UID` で対象を探します。

```powershell
Select-String -Path .\calendars\earnings.ics -Pattern "earnings-4063-","4063" -Encoding UTF8
```

## UID

UID は次の形式にします。

```text
earnings-{証券コード}-{yyyymmdd}@feeds.osnk
```

例:

```text
earnings-4063-20260428@feeds.osnk
```

日付は決算予定日を使います。時刻は変更される可能性があるため、UID には含めません。
