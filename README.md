# 職場学習アプリ（外国人材向け）

外国人材が日本語で働けるようになるまでを支援する学習アプリ。
企業のマニュアル・書類をデータ化し、「閲覧」＋「問題形式での学習」を提供する。

- **コンセプト**：全文翻訳はしない。分からない単語だけを段階的に支え、日本語で読めるようになることを目指す。
- 詳細な企画は [企画メモ.md](企画メモ.md) を参照。

## 技術スタック
| 項目 | 内容 |
|------|------|
| フロントエンド | Flutter（モバイル／タブレット／PC-Web を 1コードベース） |
| バックエンド | 自前サーバー（Cloud Functions など）※APIキー秘匿・中継 |
| データベース | kintone（データの保管・管理・編集に専念） |
| AI | 問題作成の下書き生成、単語区切り・用語集・意味の生成 |
| ソース管理 | GitHub（ソロ管理） |

---

## ディレクトリ構成（厳守）

> 本プロジェクトは下記のレイヤーファースト構成を**厳守**する。
> 出典: https://zenn.dev/kentt8046/articles/20241014-flutter-project
> 機能（feature）単位ではなく、アーキテクチャのコンポーネント単位で分割する。階層は深くしすぎない。
> （`flutter create` 生成物で配置を変えていないものは省略）

```
[project_root]/
├── assets/                         # 画像・フォントなどのリソース
├── env/                            # 環境ごとの定数・環境変数（--dart-define-from-file）
├── lib/
│   ├── main.dart                   # エントリーポイント
│   └── src/                        # 外部に公開しないコード
│       ├── root.dart               # runApp に渡すウィジェットツリーのルート
│       ├── api/                    # API通信
│       │   ├── api_impl.dart
│       │   ├── interface/
│       │   │   └── api.dart
│       │   └── response/
│       │       └── [xxx]_response.dart
│       ├── app_state/              # アプリ全体で共有する状態
│       │   └── [xxx]_state.dart
│       ├── framework/              # 各レイヤー共通コード
│       │   ├── di/                 # DI（依存性注入）
│       │   │   ├── interface/
│       │   │   │   └── service_locator.dart
│       │   │   └── service_locator_impl.dart
│       │   ├── error/              # エラー処理
│       │   │   ├── errors.dart
│       │   │   └── result.dart
│       │   ├── module/
│       │   │   ├── interface/
│       │   │   │   └── [xxx].dart
│       │   │   └── [xxx]_impl.dart
│       │   └── util/
│       ├── model/                  # ドメインのデータモデル（ロジックは持たない）
│       │   └── [xxx].dart
│       ├── repository/             # データ永続化・外部API通信
│       │   ├── interface/
│       │   │   └── [xxx]_repository.dart
│       │   └── [xxx]_repository_impl.dart
│       ├── router/                 # ルーティング
│       │   ├── route_path.dart
│       │   ├── router_config.dart
│       │   └── routes.dart
│       ├── screen/                 # 画面ごと
│       │   └── [xxx]/
│       │       ├── [xxx]_screen.dart
│       │       └── [xxx]_view_model.dart
│       ├── service/                # ビジネスロジック
│       │   ├── interface/
│       │   │   └── [xxx]_service.dart
│       │   └── [xxx]_service_impl.dart
│       ├── theme/                  # テーマ・UIスタイル
│       │   └── theme.dart
│       ├── view_controller/        # ViewModelから使うUIロジック
│       │   ├── [xxx]_impl.dart
│       │   └── interface/
│       │       ├── [xxx].dart
│       │       └── [xxx].dart
│       └── widget/                 # 複数画面で使う共通ウィジェット
│           ├── container/          # データ取得ロジックを持ち presentation へ渡す
│           │   └── [xxx]/
│           │       └── [xxx].dart
│           └── presentation/       # パラメータを受け取り表示のみ行う
│               └── [xxx]/
│                   └── [xxx].dart
└── test/
    ├── e2e/
    └── unit/
```

### 各ディレクトリの役割
| パス | 役割 |
|------|------|
| `lib/main.dart` | エントリーポイント。`lib`直下に置く |
| `lib/src/` | 外部に公開しないコードを置く層 |
| `lib/src/root.dart` | `runApp`に渡すウィジェットツリーのルート |
| `lib/src/api/` | API通信。モックしやすいよう`interface`を分け、レスポンス定義は`response`へ |
| `lib/src/app_state/` | アプリ全体で共有する状態（例：Riverpod `keepAlive: true`） |
| `lib/src/framework/` | 各レイヤー共通：DI・エラー処理・モジュール・util |
| `lib/src/model/` | ドメインのデータモデル。ビジネスロジックは持たせない |
| `lib/src/repository/` | データ永続化・外部API通信。interfaceと実装を分離 |
| `lib/src/router/` | パス定義・ルーター設定・ルート定義 |
| `lib/src/screen/` | 画面ごとに`[xxx]_screen.dart`と`[xxx]_view_model.dart`を配置 |
| `lib/src/service/` | ビジネスロジック。interfaceと実装に分離 |
| `lib/src/theme/` | アプリ全体のテーマ・UIスタイル |
| `lib/src/view_controller/` | ViewModelから利用するUIロジックを分離 |
| `lib/src/widget/` | 共通ウィジェット。`presentation`（表示のみ）と`container`（取得ロジック）に分ける |
| `assets/` | 画像・フォントなどのリソース。プロジェクトルートに置く |
| `env/` | ビルド時の定数・環境変数。環境ごとのファイル（`.json`/`.env`）で管理 |
| `test/` | `unit/` と `e2e/` に分けて配置 |

### 構成の原則
- **レイヤーファースト**：機能単位ではなく、api / repository / service などコンポーネント単位で分割する。
- **interface と impl を分離**：api / repository / service / module / di はインターフェースと実装を分け、モック・差し替えを可能にする。
- **階層を深くしすぎない**。

### ローカルパッケージを使う場合
ルート直下に `packages/` を作って配置する（モノレポ化も可）。

```
[project_root]/
├── lib/
└── packages/
    └── [other_package]/
        └── lib/
```

---

## Git運用（Git Flow）
ブランチモデルは **Git Flow** を採用する（ソロ管理）。

| ブランチ | 役割 |
|----------|------|
| `main` | リリース（安定版）。常に動く状態を保つ |
| `develop` | 開発の統合先。日々の作業はここにマージ |
| `feature/*` | 機能ごとの作業ブランチ（`develop`から分岐→`develop`へ）例：`feature/word-tap` |
| `release/*` | リリース準備（`develop`→`main`） |
| `hotfix/*` | 本番の緊急修正（`main`→`main`/`develop`） |

- 作業は必ず `feature/*` を切ってから行い、`main`に直接コミットしない。
- ソロでもPR（プルリクエスト）を作ってセルフレビュー→マージすると履歴が整理され、就活時に開発プロセスを見せやすい。
- コミットメッセージは「何を・なぜ」が分かる粒度で（例：`feat: 単語タップで意味表示`／`fix: 用語集の重複登録を修正`）。

## 開発メモ
- 企画・設計の詳細 → [企画メモ.md](企画メモ.md)
- kintoneのAPIトークン・AIのAPIキーは Flutter に埋め込まず、必ずサーバー側に隠す。
