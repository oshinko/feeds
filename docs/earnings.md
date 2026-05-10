# 決算フィード

`calendars/earnings.ics` は、対象銘柄の決算予定を管理する iCalendar フィードです。

## 購読 URL

```text
https://raw.githubusercontent.com/oshinko/feeds/main/calendars/earnings.ics
```

## 監視対象

| カレンダーID | 市場 | 企業名 | UID の接頭辞 | メモ |
| --- | --- | --- | --- | --- |
| 8306 | JP | 三菱UFJフィナンシャル・グループ | `earnings-8306-` | メガバンク、金利、金融環境 |
| 4063 | JP | 信越化学工業 | `earnings-4063-` | 半導体材料、塩ビ、シリコンウェハ |
| 3436 | JP | SUMCO | `earnings-3436-` | シリコンウェハ、半導体市況 |
| 4004 | JP | レゾナックHD | `earnings-4004-` | 半導体材料、後工程、化学 |
| 6963 | JP | ローム | `earnings-6963-` | パワー半導体、車載半導体 |
| 6890 | JP | フェローテック | `earnings-6890-` | 半導体製造装置部材、石英、セラミックス |
| 6525 | JP | KOKUSAI ELECTRIC | `earnings-6525-` | 半導体製造装置、成膜装置 |
| 5803 | JP | フジクラ | `earnings-5803-` | データセンター、光ファイバー、電線 |
| 5016 | JP | JX金属 | `earnings-5016-` | 非鉄、半導体材料、銅 |
| 1812 | JP | 鹿島建設 | `earnings-1812-` | 建設、データセンター、インフラ |
| 2914 | JP | JT | `earnings-2914-` | ディフェンシブ、高配当、為替 |
| 1605 | JP | INPEX | `earnings-1605-` | 原油、天然ガス、資源 |
| 8006 | JP | ユアサ・フナショク | `earnings-8006-` | 食品卸、不動産、内需 |
| 285A | JP | キオクシアホールディングス | `earnings-285A-` | NAND、enterprise SSD、AI ストレージ |

## 関連テーマ

### AI / データセンター / 米国ビッグテック

キオクシアの決算を見るときは、NAND、enterprise SSD、AI サーバー、hyperscaler CAPEX、クラウド投資の文脈で、米国ビッグテックの設備投資やデータセンター関連コメントも参考にします。

主な関連企業:

| カレンダーID | 市場 | 企業名 | 見るポイント |
| --- | --- | --- | --- |
| NVDA | US | NVIDIA | AI GPU、データセンター向け半導体、AI サーバー需要の先行指標 |
| MSFT | US | Microsoft | Azure、OpenAI 関連、AI データセンター投資、クラウド CAPEX |
| GOOGL | US | Alphabet | Google Cloud、TPU、AI インフラ、データセンター投資 |
| AMZN | US | Amazon | AWS、hyperscaler CAPEX、クラウド需要 |
| META | US | Meta Platforms | AI インフラ投資、GPU/サーバー投資、広告需要 |
| MU | US | Micron Technology | DRAM/NAND/SSD 市況、メモリ価格、データセンター向けメモリ需要 |
| SNDK | US | Sandisk | NAND/SSD 競合、データセンター SSD 需要、高付加価値化 |
| ORCL | US | Oracle | OCI、AI クラウド需要、hyperscaler 以外の AI インフラ投資 |

## 更新手順

共通の `.ics` 作成・更新ルールは [iCalendar 作成ルール](icalendar.md) を参照します。

既存イベントを更新する場合は、カレンダーIDまたは `UID` で対象を探します。

```powershell
Select-String -Path .\calendars\earnings.ics -Pattern "earnings-4063-","4063" -Encoding UTF8
```

## UID

UID は次の形式にします。

```text
earnings-{カレンダーID}-{yyyymmdd}@feeds.osnk
```

例:

```text
earnings-4063-20260428@feeds.osnk
earnings-285A-20260515@feeds.osnk
earnings-NVDA-20260520@feeds.osnk
```

`カレンダーID` は、このカレンダー上で企業・発行体を識別するための ID です。日本株は東証コード、米国株はティッカーを使います。

日付は決算予定日を使います。時刻は変更される可能性があるため、UID には含めません。
