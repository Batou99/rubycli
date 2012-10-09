= Ruby/CLIv2ユーザマニュアル

Copyright (C) 2010 Teradata Japan, LTD.

== よくある使いかた

=== 使用例1: Teradataに接続してすべてのレコードを取得する

Teradataに接続して、
「x」テーブルの全レコードを一気に取得して表示する例を
以下に示します。

  require 'teradata'

  Teradata.connect("dbc/user1,pass1") {|conn|
    p conn.entries("select * from x;")   # fetch and show all records
  }

まず最初はTeradata.connectメソッドを使ってTeradataに接続します。
そのときのユーザは「user」で、そのパスワードは「pass1」です。
セッション文字コードはデフォルトでUTF-8になります。

Teradata.connectメソッドはTeradataに接続したうえでブロックを実行します。
ブロック引数はTeradata::Connectionオブジェクトです。
ブロックから抜けた時点でTeradata::Connectionオブジェクトは自動的にクローズされ、
DBセッションは切断されます。

Connection#entriesメソッドはクエリーを実行してその結果を
すべてメモリ上に読み込み、配列として返すメソッドです。
とても手軽に使えますが、結果が巨大になる可能性があるときは危険です。
そのような場合は、次の例で紹介するConnection#queryメソッドを使ってください。

=== 使用例2: レコードを順番に処理する

Teradata::Connection#queryメソッドを使って、
クエリーの実行結果を1レコードずつ処理する例を次に示します。

  require 'teradata'

  Teradata.connect("dbc/test,test") {|conn|
    conn.query("select * from t") {|result_set|
      result_set.each_record do |rec|
        p rec        # => #<Record (x "a "), (y "455   ")>
        p rec[:x]    # => "a "
        p rec.to_a   # => ["a ", "455   "]
        p rec[0]     # => "a "
      end
    }
  }

Teradata::Connection#queryメソッドは、
引数に与えたSELECT文を実行するメソッドです。
queryメソッドがブロック付きで実行された場合は、
Teradata::ResultSetオブジェクトがブロックに引数として渡されます。

Teradata::ResultSetオブジェクトには多くのメソッドが定義されており、
その中のTeradata::ResultSet#each_recordメソッドを使うと
クエリーの実行結果を1レコードずつ処理することができます。

Teradata::ResultSet#each_recordメソッドのブロック引数は
Teradata::Recordオブジェクトです。
Teradata::Recordオブジェクトからは、
rec[:x]のようにフィールド名を使ってフィールドの値を得ることができます。
また、rec[0]のようにフィールドのインデックスを使うこともできます。

=== 使用例3: マルチステートメントの処理

マルチステートメントの実行結果を処理する例を次に示します。

  require 'teradata'

  Teradata.connect("dbc/test,test") {|conn|
    conn.query("select * from x; select * from y;") {|result_sets|
      result_sets.each_result_set do |rs|
        p rs.entries   # fetch and show all records at once
      end
    }
  }

Teradata::Connection#queryメソッドはマルチステートメントを
処理することもできます。マルチステートメントを実行した場合、
Teradata::Connection#queryメソッドが
ブロックに渡すTeradata::ResultSetオブジェクトからは、
#each_result_setメソッドで複数のResultSetオブジェクトを得ることができます。

=== 使用例4: UTF-8以外のセッション文字コードを使用する

UTF-8以外のセッション文字コードを使いたい場合は、次のように、
Teradata.connectメソッドの第2引数にセッション文字コード名を指定します。

  require 'teradata'

  Teradata.connect('dbc/test,test', {:session_charset => 'KANJISJIS_0S'}) {|conn|
    p conn.entries('select * from x;')
  }

Ruby/CLIv2バージョン1.0では、
一部のセッション文字コード名しかサポートしていません。
具体的には以下の4つだけです。

  * "UTF8"
  * "ASCII"
  * "KANJISJIS_0S"
  * "KANJIEUC_0U"

=== 使用例5: ログを取得する

Ruby/CLIv2を使用中に発生したイベントのログをとりたいときは、
次のようにTeradata.connectメソッドの第2引数にLoggerオブジェクト
を指定します。

  require 'teradata'
  require 'logger'

  logger = Logger.new($stderr)
  logger.sev_threshold = Logger::INFO
  Teradata.connect('dbc/test,test', {:logger => logger}) {|conn|
    p conn.entries('select * from x;')
  }

標準のLoggerオブジェクト以外でも、Loggerクラスと同じメソッド
を持つオブジェクトならばなんでも渡すことができます。


== 制限事項

このバージョンではまだ対応していない機能

  * prepared statement（version 1.1で対応予定）
  * LONG VARCHARとLONG VARBYTE（version 1.1で対応予定）
  * ログオンの暗号化
  * CLOB, BLOB
  * stored procedureの呼び出し

たぶん対応しない機能

  * DBC/SQL以外のパーティション（FastLoadやMONITORなど）

永久に対応しない機能

  * WITH


== module Teradata

TeradataモジュールはRuby/CLIライブラリの名前空間です。
Ruby/CLIライブラリが提供するクラス、モジュールはすべて
このモジュールの内部に定義されています。

また一部のユーティリティはこのモジュールの特異メソッド
として定義されています。

--- Teradata.connect(logon_string, options = {})

Teradata::Connection#openメソッドの別名です。
詳細はTeradata::Connection#openの解説を参照してください。


== class Teradata::Connection

Teradata::Connectionオブジェクトは
Teradataデータベースのセッションを表現するオブジェクトです。

=== Singleton Methods

--- new(logon_string, options = {}) -> Teradata::Connection
--- new(logon_string, options = {}) {|conn| .... }
--- open(logon_string, options = {}) -> Teradata::Connection
--- open(logon_string, options = {}) {|conn| .... }

Teradataデータベースへ接続します。
ブロックなしで呼び出した場合は
Teradata::Connectionオブジェクトを返します。

ブロックとともに呼び出した場合は、
ブロックにTeradata::Connectionオブジェクトを渡します。
また、ブロックから抜けた時点でTeradata::Connectionオブジェクトに
対してcloseメソッドを自動的に呼び出し、
データベース接続を確実に切断します。

第1引数のlogon_stringには"dbc/user,password,'account'"のような
形式の文字列か、またはTeradata::LogonStringオブジェクトを指定します。

第2引数のoptionsには、Hashオブジェクトを使って接続オプションを
指定します。指定できるオプションは以下の通りです。

: :session_charset
    セッション文字コードを"UTF8"や
    "KANJISJIS_0S"のような文字列で指定する。
: :internal_encoding
    （Ruby 1.9のみ）
    internal encodingをEncodingオブジェクトで指定する。
: :logger
    ロギングに使用するLoggerオブジェクトを指定する。

このメソッドで作成したTeradata::Connectionオブジェクトを
使い終わったときは、Teradata::Connection#closeメソッドを
呼んでデータベースへの接続を切断する必要があります。
このメソッドをブロック付きで使えば、
そのような手間を削減することができます。

使用例

    # Teradataに接続してSQLを実行
    require 'teradata'
    Teradata::Connection.open("dbc/user,pass") {|conn|
      p conn.entries("SELECT * FROM t")
    }

    # Teradataに接続してSQLを実行。セッション文字コードを指定
    require 'teradata'
    Teradata::Connection.open("dbc/user,pass", :session_charset => "KANJISJIS_0S") {|conn|
      p conn.entries("SELECT * FROM t")
    }

    # Teradataに接続してSQLを実行。ロガーを指定
    require 'teradata'
    require 'logger'
    logger = Logger.new($stderr)
    logger.sev_threshold = Logger::INFO
    Teradata::Connection.open("dbc/user,pass", :logger => logger) {|conn|
      p conn.entries("SELECT * FROM t")
    }

=== Instance Methods

--- close

このコネクションを切断します。
このコネクションから生成されたTeradata::ResultSetオブジェクトも
同時にクローズされます。

@raise Teradata::CLIError
    すでにクローズされているTeradata::Connectionオブジェクトに
    対して再度closeメソッドが呼び出された

--- update(sql) -> Teradata::ResultSet
--- execute_update(sql) -> Teradata::ResultSet

レコードを返さないSQL文sqlを実行して、
結果をTeradata::ResultSetオブジェクトで返します。

sqlが複数のSQL文を含む場合（マルチステートメント）は、
返り値のTeradata::ResultSetオブジェクトは
複数の結果を含みます。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- query(sql) {|rs| ... }
--- execute_query(sql) {|rs| ... }

レコードを返すSQL文sqlを実行して、
結果をTeradata::ResultSetオブジェクトで返します。

sqlが複数のSQL文を含む場合（マルチステートメント）は、
返り値のTeradata::ResultSetオブジェクトは
複数の結果を含みます。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- entries(sql) -> [Teradata::Record]

レコードを返すSQL文sqlを実行して、その結果を
Teradata::Recordオブジェクトの配列として返します。

このメソッドはSQL文の結果を一度にメモリ上に読み込むため、
大量のレコードが返ってくる可能性がある場合には使うべきではありません。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- transaction { .... }

Teradata RDBMSの明示的トランザクションを
非ANSIモード（Teradataモード）で処理します。

このメソッドは、まずBEGIN TRANSACTION文を実行し、
ブロックを実行してからEND TRANSACTION文を実行します。
ただし、例外によってブロックから抜けた場合は、
END TRANSACTIONの代わりにABORT文を発行して
トランザクションをアボートします。
Teradata::Connection#abortメソッドによって明示的に
ABORT文を実行した場合もトランザクションはアボートされます。

使用例

    # 3つのDELETE文を1つのトランザクションで実行
    # ……何もエラーが起きなければ
    # トランザクションはコミットされる
    require 'teradata'
    Teradata.connect('dbc/user,pass') {|conn|
      conn.transaction {
        conn.update "DELETE FROM x"
        conn.update "DELETE FROM y"
        conn.update "DELETE FROM z"
      }
    }

    # トランザクションの途中でアボートする
    # ……トランザクションはロールバックされる
    require 'teradata'
    Teradata.connect('dbc/user,pass') {|conn|
      conn.transaction {
        conn.update "DELETE FROM x"
        conn.update "DELETE FROM y"
        conn.abort
        conn.update "DELETE FROM z"
      }
    }

    # トランザクションの途中で例外を投げる
    # ……トランザクションはロールバックされる
    require 'teradata'
    Teradata.connect('dbc/user,pass') {|conn|
      conn.transaction {
        conn.update "DELETE FROM x"
        conn.update "DELETE FROM y"
        raise ArgumentError, "stop!"
        conn.update "DELETE FROM z"
      }
    }

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- abort

ABORT文を発行します。
正常にABORT文が実行された場合は例外Teradata::UserAbortが発生します。

@raise Teradata::UserAbort
    正常にABORT文が実行されたとき
@raise Teradata::SQLError
    ABORT文の実行自体が失敗したとき

--- info -> Teradata::SessionInfo

セッション情報を返します。
HELP SESSIONで得られる情報と同じです。

--- root_database -> Teradata::User
--- dbc -> Teradata::User

DBCに対応するTeradata::Userオブジェクトを返します。

--- database(name) -> Teradata::Database

名前がnameであるデータベースに対応する
Teradata::Databaseオブジェクトを返します。

--- tables(db) -> [Teradata::Table]

データベースdbの直下に定義されているテーブルの一覧を
Teradata::Tableオブジェクトの配列として返します。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- views(db) -> [Teradata::View]

データベースdbの直下に定義されているビューの一覧を
Teradata::Viewオブジェクトの配列として返します。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- objects(db) -> [Teradata::DBObject]

データベースdbの直下に定義されている
データベースオブジェクトの一覧を
Teradata::DBObjectオブジェクトの配列として返します。

各オブジェクトのクラスは、データベースオブジェクトの
型によってTeradata::TableやTeradata::Viewなどの最も
適切なクラスが選択されます。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき


== class Teradata::ResultSet

include Enumerable

Teradata::ResultSetはSQL文の結果を表現するクラスです。
ステータスコードやメッセージ、レコードなどを保持します。

Teradata::ResultSetオブジェクトがマルチステートメント
を実行した結果として生成された場合、Teradata::ResultSet
オブジェクトは複数の結果を持ちます。nextメソッドを呼ぶと
「次の」ResultSetオブジェクトを得ることができます。

=== Instance Methods

--- error_code -> Integer

Teradata RDBMSのエラーコードを返します。

--- info -> Integer

Teradata RDBMSの情報コードを返します。

--- message -> String

Teradata RDBMSのメッセージを返します。
SQL文が成功した場合もメッセージは存在します。

--- statement_no -> Integer

ステートメント番号を返します。

--- activity_count -> Integer

SQL文によって処理された行数を返します
（BTEQのActivityCountと同じ）。

--- n_fields -> Integer

このリザルトセットのレコードが持つフィールド数を返します。

--- warning_code -> Integer

Teradata RDBMSの警告コードを返します。
警告が発生していない場合は0を返します。

--- next -> Teradata::ResultSet

このTeradata::ResultSetオブジェクトが
マルチステートメントの結果である場合、
次のステートメントに対する
Teradata::ResultSetオブジェクトを返します。

このTeradata::ResultSetオブジェクトが
マルチステートメントの最後の文に対する結果であるか、
マルチステートメントでなかった場合は、nilを返します。

--- each_result_set {|rs| .... }

このTeradata::ResultSetオブジェクトから順番に、
すべてのTeradata::ResultSetオブジェクトをブロックに渡します。
対応するブロックが終了した時点で
Teradata::ResultSetオブジェクトは自動的にクローズされます
（つまりそれ以降は結果を取り出すことができなくなります）。

このTeradata::ResultSetオブジェクトが
マルチステートメントの結果でない場合でも動作します
（その場合、ブロックは1回しか実行されません）。

--- each_records {|rec| .... }
--- each {|rec| .... }

このリザルトセットが持つレコードに対して順番に繰り返します。
レコードはTeradata::Recordオブジェクトです。
すべてのレコードを処理したあと、
このTeradata::ResultSetオブジェクトは自動的にクローズされます。

@raise Teradata::ConnectionError
    すでにクローズされたTeradata::ResultSetオブジェクトに
    対してこのメソッドを呼んだときに発生する

--- entries -> [Teradata::Record]

このリザルトセットが持つレコードをすべて読み込み、
Teradata::Recordオブジェクトの配列として返します。

@raise Teradata::ConnectionError
    すでにクローズされたTeradata::ResultSetオブジェクトに
    対してこのメソッドを呼んだときに発生する

--- close

このTeradata::ResultSetオブジェクトをクローズします。
このメソッドを呼んだあとは、
このTeradata::ResultSetオブジェクトからは
レコードが取得できなくなります。


== class Teradata::Record

include Enumerable

SQL文の実行結果のレコードを表現するクラスです。

=== Instance Methods

--- size -> Integer

このレコードのフィールド数を返します。

--- [](key) -> String | Integer | Time

keyに対応するフィールドの値を返します。
keyにはフィールド名（文字列かSymbol）か、
フィールドのインデックス（整数）を指定できます。

@raise ArgumentError
    keyに対応するフィールドが存在しない

使用例:

    conn.query("SELECT 13 as num, 'str' as str") {|rs|
      rs.each do |record|
        p record[:num]    # => 13
        p record[0]       # => 13
        p record[:str]    # => "str"
        p record[1]       # => "str"
        record[:nosuch]   # ArgumentError
        record[2]         # ArgumentError
      end
    }

--- field(name) -> Teradata::Field
--- field(index) -> Teradata::Field

keyに対応するフィールドをTeradata::Fieldオブジェクトとして返します。
keyにはフィールド名（文字列かSymbol）か、
フィールドのインデックス（整数）を指定できます。

--- each_field {|f| ... }

このレコードの持つフィールドに対して繰り返します。
ブロック引数のfはTeradata::Fieldオブジェクトです。

--- each_value {|val| ... }
--- each {|val| ... }

このレコードの持つフィールドの値に対して繰り返します。

--- to_a -> [Object]

このレコードの持つフィールドの値を配列として返します。

使用例:

    conn.query("SELECT 13 as num, 'str' as str") {|rs|
      rs.each do |record|
        p record.to_a     # => [13, "str"]
      end
    }


== class Teradata::Field

行のフィールドを表現するクラスです。

=== Instance Methods

--- value -> String | Integer | Time
--- data  -> String | Integer | Time

このフィールドの値を返します。
SQLの値からRubyのオブジェクトへの変換規則は次の通りです。

: NULL
    常にnil。

: CHAR, VARCHAR, TIME, TIMESTAMP, BYTE, VARBYTE
    Stringオブジェクト。CHAR型の値の場合は、
    末尾にパディングのための空白文字が入る場合があります。

: BYTEINT, SHORTINT, INT, BIGINT
    Integerオブジェクト。

: DATE
    Timeオブジェクト。時刻部分は00:00:00.0になります。

: DECIMAL
    現在のところはStringオブジェクトだが、
    将来のバージョンではBigDecimalに変換される予定。

--- name -> String

このフィールドのフィールド名を返します。
フィールド名がない場合は空文字列を返します。

--- format -> String

このフィールドの表示フォーマットを文字列で返します。

--- title -> String

このフィールドのタイトルを返します。

--- type -> String

このフィールドのCLIレベルでの型名（"INTEGER_NN"など）を返します。

--- type_code -> Integer

このフィールドのCLIレベルでの型コード（487など）を返します。

--- null? -> bool

このフィールドがNULLならtrueを返します。


== class Teradata::Database

Teradataのデータベースを表現するクラスです。

=== Instance Methods

--- user? -> bool

このオブジェクトがUserオブジェクトならtrueを返します。

--- name -> String

データベース名を返します。

--- owner -> Teradata::Database
--- parent -> Teradata::Database

このデータベースが所属する（親の）データベースを返します。

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- parents -> [Teradata::Database]

このデータベースが所属する（親の）データベースすべてを配列で返します。
この配列は直接の親から始まって、DBCで終わります。

使用例:

    p conn.database('someuser').parents
            # => [#<Teradata::User sysdba>, #<Teradata::User DBC>]

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- children -> [Teradata::Database]

このデータベースに所属する（子の）データベースを配列で返します。

使用例:

    p conn.dbc.children
            # => [#<Teradata::Database dbcmngr>,
            #     #<Teradata::User SystemFe>,
            #     #<Teradata::User sysdba>,
            #     ...]

@raise Teradata::SQLError
    SQL文の実行中にエラーが発生したとき

--- current_perm -> Integer
--- own_current_perm -> Integer

このデータベース単独の（子の領域を含まない）current permを返します。

--- max_perm -> Integer
--- own_max_perm -> Integer

このデータベース単独の（子の領域を含まない）max permを返します。

--- peak_perm -> Integer
--- own_peak_perm -> Integer

このデータベース単独の（子の領域を含まない）peak permを返します。

--- total_current_perm -> Integer

このデータベースの子の領域までを含めたときのcurrent permを返します。

--- total_max_perm -> Integer

このデータベースの子の領域までを含めたときのmax permを返します。

--- total_peak_perm -> Integer

このデータベースの子の領域までを含めたときのpeak permを返します。

--- tables -> [Teradata::Table]

このデータベースの直下に存在するテーブルのリストを
Teradata::Tableの配列として返します。


== class Teradata::User < Teradata::Database

Teradataのユーザを表現するクラスです。


== class Teradata::DBObject

Teradataのデータベースオブジェクト（テーブルやビュー）
を表現するクラスすべてのスーパークラスです。
Teradata::DBObjectクラスは抽象クラスなので、
このクラス自体はインスタンスを生成できません。

=== Singleton Methods

--- new(database, name) -> Teradata::DBObject
--- new(name) -> Teradata::DBObject

Teradata::DBObjectの下位クラスを生成します。

=== Instance Methods

--- name -> String

このオブジェクトの名前をデータベース名付きで返します。

--- unqualified_name -> String

このオブジェクトのデータベース名が付かない名前を返します。

--- database -> String

このオブジェクトが定義されているデータベースの名前を返します。
このオブジェクトを1引数のTeradata::DBObject.newで
生成した場合はnilを返します。


== class Teradata::Table < Teradata::DBObject

Teradataのテーブルを表現するクラスです。


== class Teradata::View < Teradata::DBObject

Teradataのビューを表現するクラスです。


== class Teradata::LogonString

ログオン文字列（"dbc/user,pass,acnt"）を表現するクラスです。

=== Singleton Methods

--- parse(str) -> Teradata::LogonString

ログオン文字列strをパースして
Teradata::LogonStringオブジェクトを生成します。

使用例:

    require 'teradata'
    p Teradata::LogonString.parse("dbc/user,pass,'acnt'")
            # => #<Teradata::LogonString dbc/user,pass,'acnt'>

=== Instance Methods

--- tdpid -> String

TDP-IDを返します。

--- user -> String

ユーザ名を返します。

--- password -> String

パスワードを返します。

--- account -> String

アカウント文字列を返します。

--- to_s -> String

ログオン文字列として有効な（bteqなどが受け付ける）
形式の文字列を返します。

--- safe_string -> String

パスワードをマスクした文字列を返します。


== class Teradata::SessionInfo

セッションの情報を表現するクラスです。
SQL文のHELP SESSIONで得られる情報と同じです。

=== Instance Methods

--- user_name -> String

ユーザ名

--- account_name -> String

アカウント名

--- logon_date

--- logon_time

--- current_database -> String

現在のデフォルトデータベース

--- collation

--- character_set -> String

セッション文字コード

--- transaction_semantics -> String

トランザクションモードを返します。
文字列"Teradata"または"ANSI"です。

--- current_dateform

--- timezone

--- default_character_type

--- export_latin

--- export_unicode

--- export_unicode_adjust

--- export_kanjisjis

--- export_graphic

--- default_date_format

--- radix_separator

--- group_separator

--- grouping_rule

--- currency_radix_separator

--- currency_graphic_rule

--- currency_grouping_rule

--- currency_name

--- currency

--- iso_currency

--- dual_currency_name

--- dual_currency

--- dual_iso_currency

--- default_byteint_format

--- default_integer_format

--- default_smallint_format

--- default_numeric_format

--- default_real_format

--- default_time_format

--- default_timestamp_format

--- current_role

--- logon_account

--- profile

--- ldap

--- audit_trail_id

--- current_isolation_level

--- default_bigint_format

--- query_band -> String

クエリーバンドを返します。
クエリーバンドが設定されていない場合はnilを返します。
