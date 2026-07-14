# 決算フィード

`calendars/earnings.ics` は、対象銘柄の決算予定を管理する iCalendar フィードです。

## 購読 URL

```text
https://raw.githubusercontent.com/oshinko/feeds/main/calendars/earnings.ics
```

## 監視対象

監視対象銘柄の正本は [data/stocks.json](../data/stocks.json) です。`items` 配列に銘柄を定義します。スプレッドシート等で扱うための CSV として [data/stocks.csv](../data/stocks.csv) も併置します。

| field | 意味 |
| --- | --- |
| `tier` | 銘柄の階層を表す数値。値が小さいほど上位の階層として扱います |
| `tags` | 銘柄に付与する分類です。JSON では配列、CSV ではカンマ区切りの文字列として扱います |
| `note` | 銘柄を見る観点や補足説明です |

| tag | 意味 |
| --- | --- |
| `radar` | 参考・見守り対象。周辺テーマや比較対象として見る銘柄 |
| `earnings` | 決算予定を調査し、カレンダーへ新規登録する対象銘柄 |

### 決算登録対象

決算予定の調査・新規登録対象は、`data/stocks.json` で `earnings` タグを持つ銘柄です。`radar` は参考・見守り対象を示す分類であり、決算登録対象を直接決めるものではありません。

新しく決算登録対象にする場合は、先に `data/stocks.json` へ銘柄を追加し、`earnings` タグを付けます。`earnings` タグを外した場合は新規予定の追加を停止しますが、登録済みのイベントは自動削除しません。既存イベントを削除するのは、重複、中止、誤登録などを個別に確認できた場合に限ります。

## 関連テーマ

### AI / データセンター / 米国ビッグテック

キオクシアの決算を見るときは、NAND、enterprise SSD、AI サーバー、hyperscaler CAPEX、クラウド投資の文脈で、米国ビッグテックの設備投資やデータセンター関連コメントも参考にします。関連企業は `data/stocks.json` で `radar` タグを付けて管理します。

### マクロイベント / 金融政策

`calendars/earnings.ics` はファイル名上は決算フィードですが、購読先を増やさずに運用するため、監視銘柄に影響しやすいマクロイベントや金融政策イベントも同じファイルで管理します。

マクロイベントと金融政策イベントは、銘柄の `earnings` タグとは独立して登録します。

#### 常時追跡

次のイベントは、公式機関が公表する予定を確認し、継続的に登録します。

| イベント | 主な確認元 |
| --- | --- |
| 米国 CPI | 米労働省 BLS |
| 米国雇用統計 | 米労働省 BLS |
| 米国 PCE・GDP | 米商務省 BEA |
| FOMC | FRB |
| 日銀金融政策決定会合 | 日本銀行 |
| 日銀「主な意見」 | 日本銀行 |

#### スポット登録

次のイベントは常時登録せず、金利、ドル円、NASDAQ、半導体・AI関連株への影響が大きいと判断した場合に登録します。

- 米国 PPI
- 米国小売売上高
- 新規失業保険申請件数
- フィラデルフィア連銀製造業指数
- 米国輸入・輸出物価
- 米国住宅着工・建築許可
- 米国鉱工業生産・設備稼働率
- ミシガン大学消費者信頼感・期待インフレ
- 米国耐久財受注
- FOMC 議事要旨
- ジャクソンホール経済政策シンポジウム

スポット登録したイベントは、次回以降も機械的に継続登録する対象とはしません。常時追跡へ変更する場合は、この一覧と更新ルールを先に更新します。

米国雇用統計は、米労働省 BLS の `Schedule of Releases for the Employment Situation` で発表日と時刻を確認して登録します。通常は第1金曜日が多いものの、祝日などにより木曜日や翌週にずれる場合があるため、機械的な曜日ルールではなく BLS 公式スケジュールを優先します。

米国 CPI は、米労働省 BLS の `Schedule of Releases for the Consumer Price Index` で発表日と時刻を確認して登録します。総合 CPI と Core CPI、住居費、サービス価格を主な確認対象とします。

米国 PCE と GDP は、米商務省 BEA の `Release Schedule` で発表日と時刻を確認して登録します。Personal Income and Outlays と GDP が同日同時刻に発表される場合は、カレンダーの視認性を優先して `米PCE・GDP 発表` の複合イベントとして登録します。

FOMC は、FRB 公式の `FOMC Meetings` カレンダーで会合日を確認して登録します。原則として米国現地の会合最終日を UID に使い、日本時間では結果発表・記者会見を確認する未明の時刻で登録します。SEP（Summary of Economic Projections、ドットチャート）公表対象会合は `SUMMARY` に `SEP` を含めます。

日銀金融政策決定会合は、日銀公式の Monetary Policy Meetings の予定表で会合日と結果公表日を確認して登録します。原則として結果公表日を終日イベントとして登録します。展望レポート公表対象会合は `DESCRIPTION` に明記します。

日銀「主な意見」は、日銀公式の Monetary Policy Meetings の予定表で公表日を確認して登録します。原則として公表日の 8:50（日本時間）で登録し、`DESCRIPTION` に対象となる会合日を明記します。

## 更新手順

共通の `.ics` 作成・更新ルールは [iCalendar 作成ルール](icalendar.md) を参照します。

既存イベントを更新する場合は、銘柄コード、ティッカー、または `UID` で対象を探します。

```powershell
Select-String -Path .\calendars\earnings.ics -Pattern "earnings-4063-","4063" -Encoding UTF8
```

監視対象銘柄を更新する場合は、`data/stocks.json` を更新し、CSV を再生成します。`data/stocks.json` を正本とし、`data/stocks.csv` は外部表示・スプレッドシート利用のための派生データとして扱います。

```powershell
.\scripts\export-stocks-csv.ps1
```

CSV は `market`, `tier`, `symbol` の昇順で出力します。

## 更新ルール

決算イベントは原則として、公式 IR カレンダー、適時開示、または信頼できる決算カレンダーで確認できたものを登録します。時刻が未確認の場合は終日イベントとし、`SUMMARY` または `DESCRIPTION` に時刻未定であることを明記します。

決算発表前の売上高・出荷額速報など、決算を読むうえで重要な先行指標が公式予定として確認できる場合は、決算関連イベントとして登録します。

配当権利落日は、監視銘柄ごとの必須確認対象とし、原則として銘柄別イベントとして登録します。市場全体の包括イベントとしての配当権利落日は、個別銘柄の確認が不要な場合を除き登録しません。

株式分割、スピンオフ、ティッカー変更、上場廃止、市場変更などのコーポレートアクションは、効力発生日など投資行動や確認行動に影響する日付が明確なものを登録します。自社株買いなどの期間イベントは、通常は開始日・終了予定日を機械的には登録せず、重要度が高い場合のみ登録します。

米国株のイベントは、米国現地日付、市場引け後・寄り前などのタイミング、日本時間での該当日を `DESCRIPTION` に明記します。

マクロイベントは、公式機関の発表予定、中央銀行カレンダー、または信頼できる経済カレンダーで確認できたものを登録します。同時刻に複数の重要指標が発表される場合は、カレンダーの視認性を優先して 1 つの複合イベントとして登録します。

米国雇用統計を登録する場合は、`SUMMARY` を `米雇用統計 発表` とし、`DESCRIPTION` に対象月、BLS 発表予定、米東部時間、日本時間、NFP、失業率、平均時給、労働参加率、過去分改定を確認する旨を記載します。米国夏時間中は原則 21:30 JST、標準時間中は原則 22:30 JST として登録します。

米国 CPI を登録する場合は、`SUMMARY` を `米CPI 発表` とし、`DESCRIPTION` に対象月、BLS 発表予定、米東部時間、日本時間、総合 CPI、Core CPI、住居費、サービス価格を確認する旨を記載します。米国夏時間中は原則 21:30 JST、標準時間中は原則 22:30 JST として登録します。

米国 PCE と GDP を複合イベントとして登録する場合は、`SUMMARY` を `米PCE・GDP 発表` とし、`DESCRIPTION` に対象月、Personal Income and Outlays、PCE Price Index、Core PCE、対象四半期の GDP 速報値・改定値・確報値を記載します。

FOMC を登録する場合は、`SUMMARY` を `FOMC 結果発表` とし、SEP 公表対象会合では `FOMC 結果発表・SEP` とします。`DESCRIPTION` には会合日、SEP の有無、米国現地日付、日本時間、政策金利、声明文、記者会見を確認する旨を記載します。

日銀金融政策決定会合を登録する場合は、`SUMMARY` を `日銀 金融政策決定会合 結果公表` とし、`DESCRIPTION` に会合日、政策変更の有無、総裁記者会見、展望レポート公表対象かどうかを記載します。

日銀「主な意見」を登録する場合は、`SUMMARY` を `日銀 金融政策決定会合 主な意見 公表` とし、`DESCRIPTION` に対象となる会合日と公表予定時刻を記載します。

イベントは可能な限り `DTSTART` の時系列順に並べます。同じ日のイベントは、時刻付きイベント、終日イベント、関連イベントの見やすさを考慮して配置します。

既存イベントの `目安` 表記は、公式情報で確認できた場合に外します。公式確認できない場合は `目安` のまま残すか、不要になった時点で削除候補とします。

## UID

UID はイベント種別ごとに次の形式にします。

```text
# 決算
earnings-{symbol}-{yyyymmdd}@feeds.osnk

# 決算関連の速報
earnings-flash-{symbol}-{yyyymmdd}@feeds.osnk

# 決算説明会
earnings-briefing-{symbol}-{yyyymmdd}@feeds.osnk

# 配当権利落日
dividend-exdate-{symbol}-{yyyymmdd}@feeds.osnk

# 株式分割などのコーポレートアクション
corporate-action-{symbol}-{yyyymmdd}-{slug}@feeds.osnk

# 米国マクロ指標
macro-us-{slug}-{yyyymmdd}@feeds.osnk

# 日本マクロ指標
macro-jp-{slug}-{yyyymmdd}@feeds.osnk

# 金融政策
fomc-{yyyymmdd}@feeds.osnk
fomc-minutes-{yyyymmdd}@feeds.osnk
boj-mpm-{yyyymmdd}@feeds.osnk
boj-mpm-opinions-{yyyymmdd}@feeds.osnk
```

例:

```text
earnings-4063-20260428@feeds.osnk
earnings-285A-20260515@feeds.osnk
earnings-NVDA-20260520@feeds.osnk
earnings-flash-6146-20260706@feeds.osnk
earnings-briefing-6146-20261023@feeds.osnk
dividend-exdate-2914-20260629@feeds.osnk
corporate-action-8035-20261001-stock-split@feeds.osnk
macro-us-pce-gdp-claims-durable-20260625@feeds.osnk
macro-us-cpi-20260714@feeds.osnk
macro-us-employment-situation-20260702@feeds.osnk
macro-us-pce-gdp-20260730@feeds.osnk
fomc-20260729@feeds.osnk
boj-mpm-20260731@feeds.osnk
boj-mpm-opinions-20260810@feeds.osnk
```

`symbol` は銘柄マスターの `symbol` を使います。日本株は東証コード、米国株はティッカーを使います。

日付はイベント日を使います。時刻は変更される可能性があるため、UID には含めません。
