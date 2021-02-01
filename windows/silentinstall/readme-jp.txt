Windowsの自動インストール実行手順

1) windows\silentinstall以下をc:\tempにCOPY
silentinstall.batを編集し、下記を適切な値に変更してください。
INSTALLDIR  インストール先
/instance XXX   インスタンス名
SUPERSERVERPORT スーパサーバポート番号
WEBSERVERPORT   内部WEBサーバポート番号

詳細はマニュアルをごらんください。
 https://docs.intersystems.com/iris20201j/csp/docbookj/Doc.View.cls?KEY=GCI_windows#GCI_windows_silentinst


2) C:\temp\silentinstall\にIRISキットをCOPY

下記のような配置となります。
C:\temp\silentinstall>dir
 ドライブ C のボリューム ラベルは Windows です
 ボリューム シリアル番号は FC06-6E6E です
 C:\temp\silentinstall のディレクトリ
2020/11/26  17:58    <DIR>          .
2020/11/26  17:58    <DIR>          ..
2020/11/09  18:50       264,159,944 IRIS-2020.1.0.215.0-win_x64.exe
2020/11/26  17:58    <DIR>          project
2020/11/26  17:57               808 readme-jp.txt
2020/11/09  19:18                96 remove.bat
2020/11/26  17:30               385 silentinstall.bat

3)コマンドプロンプト(DOS窓)を管理者として実行
C:\>cd \temp\silentinstall
C:\temp\silentinstall>silentinstall.bat

4) インストール完了後のテスト方法
成功した場合、下記のREST/APIが使用できるようになっているはずです。
C:\>curl -H "Content-Type: application/json; charset=UTF-8" -H "Accept:application/json" "http://localhost:52774/csp/myapp/get" --user "appuser:sys"
{"HostName":"DESKTOP-XXXXX","UserName":"appuser","Status":"OK","TimeStamp":"11/26/2020 17:44:40","ImageBuilt":"11/26/2020 17:42:49"}

5) 削除
C:\temp\silentinstall>remove.bat

