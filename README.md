# オボエ - 漢字学習Webアプリケーション

JLPT（日本語能力試験）の漢字学習を支援するWebアプリケーションです。  
6名のチーム「積み木（TSUMIKI）」で開発し、発表会で **2位** を獲得しました。

## 概要

| 項目 | 内容 |
|------|------|
| 開発期間 | 2026年1月〜2月（約3週間） |
| チーム | 6名（チーム名：積み木） |
| 発表結果 | 2位 |
| アーキテクチャ | JSP/Servlet（MVC） |
| DB | Oracle Database |
| 開発環境 | Eclipse / Apache Tomcat / Git |

## 主な機能

- **会員機能** — 会員登録・ログイン・ID/ニックネーム重複チェック
- **漢字学習** — JLPTレベル別（N5〜N1）・セクター単位での学習
- **テスト機能** — 4択クイズ形式、ランダム出題、正誤記録
- **マイページ** — 正答率・連続学習日数・レベル別進捗の統計表示
- **漢字データ** — Javaによるスクレイピングで収集

## データベース設計

3つのテーブルで構成しています。

```
account（会員テーブル）
├── accID (PK, Auto Increment)
├── userID, userPW, email, phone, nickname
├── attendance, regDate
│
kanji（漢字テーブル）
├── kanjiID (PK, Auto Increment)
├── kanjiINDEX, kanji
├── onyomi(1~3), kunyomi(1~3)
├── korean_meaning, meaning_description
├── example(1~3)
├── jlpt_level, sector, index_num
│
kanji_log（学習ログテーブル）
├── logID (PK)
├── accID (FK → account)
├── kanjiID (FK → kanji)
├── is_correct, studied_at
```

## 担当箇所（ジェ・チョルク）

| 担当領域 | 詳細 |
|----------|------|
| ログDB設計・管理 | kanji_logテーブルの設計、FK制約、統計集計用SQL |
| 会員DB管理 | AccountDAO — 登録・ログイン・重複チェック・accID取得 |
| テスト機能 | 4択クイズのロジック、ランダム不正解生成、結果記録 |
| マイページ連携 | MypageDAO — 正答率・学習数・連続日数の集計 |

## 技術スタック

**バックエンド:** Java / Servlet  
**フロントエンド:** JSP / Scriptlet / CSS  
**データベース:** Oracle Database  
**その他:** Web Crawling (Java) / Git

## プロジェクト構成

```
TSUMIKI_01/
├── src/
│   └── model/
│       ├── AccountDAO.java    # 会員DB操作
│       ├── AccountDTO.java    # 会員データ
│       ├── KanjiDAO.java      # 漢字DB操作
│       ├── KanjiDTO.java      # 漢字データ
│       ├── KanjiLogDAO.java   # 学習ログDB操作
│       ├── KanjiLogDTO.java   # ログデータ
│       └── MypageDAO.java     # マイページ統計
├── WebContent/
│   ├── css/
│   ├── kanjiStudy.jsp         # 学習画面
│   ├── kanjiTest.jsp          # テスト画面
│   ├── login.jsp              # ログイン
│   ├── register.jsp           # 会員登録
│   └── mypage.jsp             # マイページ
├── sql/
│   └── create_tables.sql      # テーブル作成SQL
└── README.md
```

## 学び

- 初のチーム開発で、テーブル設計変更やDAO変数名不一致などの課題を経験
- 設計段階での合意形成とGit branch運用の重要性を学んだ
- DB設計の判断がアプリ全体の機能に影響することを実感

## チームメンバー

| 名前 | 役割 |
|------|------|
| 전재현（リーダー） | Git管理・コード統合、学習機能 |
| 오태영（サブリーダー） | 漢字DB設計、復習機能 |
| 남승호 | 漢字データクローリング、会員登録・ログイン |
| 안승건 | UI/UXデザイン |
| **ジェ・チョルク** | **ログDB設計、会員DB管理、テスト機能** |
| 이유진 | テスト機能、マイページ |