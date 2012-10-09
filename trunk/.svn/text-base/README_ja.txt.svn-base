Ruby/CLIv2 README
=================

  Ruby/CLIv2はRubyからTeradata RDBMSにアクセスするための
  拡張ライブラリです。Teradataのネイティブインターフェイス
  であるCLIv2を使ってTeradataに接続します。


必要な環境
----------

  * LinuxまたはWindows
  * Ruby 1.8系最新、または1.9 HEAD
  * Teradata CLIv2

  自分でコンパイルする場合はさらに以下の環境が必要です。
  Windows環境ではVisual C++ 6.0以上を使ってください。

  * Cコンパイラ
  * make


インストール
------------

  Linux/UNIXの場合:

  $ make unix
  $ su
  # ruby setup.rb install

  Windowsの場合:

  > "C:\Program Files\Visual Studio 9.0\VC\bin\vcvars32"
    ※Visual Studioのバージョンによってパスが違います！
      上記はVisual Studio 2008の場合です
  > nmake win
  > ruby setup.rb install

  !!! 注意 !!!

  Ruby 1.8をスペースの入ったパスにインストールしている
  とコンパイルに失敗します。自分で拡張ライブラリなどの
  コンパイルを行う場合は、あらかじめRubyを C:\ruby など
  のスペースの入らないパスにインストールしておくことを
  お勧めします。


テスト方法
-----------

  1. Ruby/CLIv2をインストールしておく
  2. テスト用に新しいTeradataユーザを作成する（例：rubycli）
  3. 環境変数TEST_LOGON_STRINGにそのユーザのログオン文字列
     をセットする（例：dbc/rubycli,password）
  4. ruby test/all を実行する

  !!! 注意 !!!

  Teradata V12より前のバージョンを使っている場合、
  BIGINTがないために一部のテストが失敗しますが、
  その他の部分の動作には問題ありません。


ドキュメント
------------

  doc/UserManual.txt を参照してください。
  近いうちにもうちょっとまともなマニュアルを用意します。


ライセンス
----------

  Ruby/CLIv2はGNU LGPL 2.1でライセンスします。
  著作権表示は以下の通りです。

  Copyright (C) 2009,2010 Teradata Japan, LTD.

  This program is free software.
  You can distribute/modify this program under the terms of
  the GNU LGPL2, Lesser General Public License version 2.
  For details of GNU LGPL2.1, see the file "COPYING".


連絡先
------

  青木峰郎 / Minero Aoki <minero.aoki@teradata.com>
  日本テラデータ株式会社 / Teradata Japan, LTD.

