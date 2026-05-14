# 決算フィード

`calendars/earnings.ics` は、対象銘柄の決算予定を管理する iCalendar フィードです。

## 購読 URL

```text
https://raw.githubusercontent.com/oshinko/feeds/main/calendars/earnings.ics
```

## 監視対象

監視対象銘柄の正は [data/stocks.json](../data/stocks.json) です。`items` 配列に銘柄を定義します。スプレッドシート等で扱うための CSV として [data/stocks.csv](../data/stocks.csv) も併置します。

| segment | 意味 |
| --- | --- |
| `core` | 独自インデックスの算出対象。継続評価する中核銘柄 |
| `radar` | 参考・見守り対象。周辺テーマや比較対象として見る銘柄 |

| field | 意味 |
| --- | --- |
| `tier` | 銘柄の階層を表す数値。値が小さいほど上位の階層として扱います |

## 関連テーマ

### AI / データセンター / 米国ビッグテック

キオクシアの決算を見るときは、NAND、enterprise SSD、AI サーバー、hyperscaler CAPEX、クラウド投資の文脈で、米国ビッグテックの設備投資やデータセンター関連コメントも参考にします。関連企業は `data/stocks.json` で `segment: "radar"` として管理します。

## 更新手順

共通の `.ics` 作成・更新ルールは [iCalendar 作成ルール](icalendar.md) を参照します。

既存イベントを更新する場合は、銘柄コード、ティッカー、または `UID` で対象を探します。

```powershell
Select-String -Path .\calendars\earnings.ics -Pattern "earnings-4063-","4063" -Encoding UTF8
```

監視対象銘柄を更新する場合は、`data/stocks.json` を更新し、CSV を再生成します。`data/stocks.json` を正とし、`data/stocks.csv` は外部表示・スプレッドシート利用のための派生データとして扱います。

```powershell
.\scripts\export-stocks-csv.ps1
```

CSV は `market`, `segment`, `tier`, `symbol` の昇順で出力します。

## UID

UID は次の形式にします。

```text
earnings-{symbol}-{yyyymmdd}@feeds.osnk
```

例:

```text
earnings-4063-20260428@feeds.osnk
earnings-285A-20260515@feeds.osnk
earnings-NVDA-20260520@feeds.osnk
```

`symbol` は銘柄マスターの `symbol` を使います。日本株は東証コード、米国株はティッカーを使います。

日付は決算予定日を使います。時刻は変更される可能性があるため、UID には含めません。
