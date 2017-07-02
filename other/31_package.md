# Rcppを用いたパッケージ作成

自作のパッケージでRcppを利用する方法を解説します。

このページのほとんど内容は Hadley Wickham 氏の [R packages のサイト](http://r-pkgs.had.co.nz/src.html)の内容を元にしています。

通常のユーザーにはパッケージを作成する必要はないと考えるかもしれないが、Rcppで書いた関数はパッケージとして保存しておくことを薦める。なぜなら、Rcpp関数をパッケージ化しない場合、Rcppで書いた関数を利用するためには毎回 `sourceCppRcpp` でコンパイルしてRにロードする必要があります。それに対して、パッケージ化では、コンパイル済みのRcpp関数を保存しておき、使うときには`library()` でロードするだけで済むようになるので、時間が節約できます。

##手順

パッケージフォルダを作業フォルダとして指定した状態で。`devtools::use_rcpp()`関数を実効します。

```
> devtools::use_rcpp()
Adding Rcpp to LinkingTo and Imports
Creating src/ and src/.gitignore
Next, include the following roxygen tags somewhere in your package:
#' @useDynLib MyPackage
#' @importFrom Rcpp sourceCpp
```

これによりパッケージでRcppを利用するための下の設定を行われる。

* `src` フォルダが作成されます。Rcppで書いたソースコードは の中に配置します。
* `DESCRIPTION`ファイルに以下の記述を追加する

```
LinkingTo: Rcpp
Imports: Rcpp
```

* `NAMESPACE`ファイルに以下の記述を追加する

```
useDynLib(mypackage)
importFrom(Rcpp, sourceCpp)
```

* Rcpp関数のコンパイルで生じる一時ファイルをgitが無視するように。`.gitignore` ファイルの内容を設定します。

`devtools::use_rcpp()`関数を実効した後に
* パッケージの "Rのソースコード" のどこかに、次の roxygen タグを記述します。

```
#' @useDynLib your-package-name
#' @importFrom Rcpp sourceCpp
NULL
```


Writing a `.onUnload()` function.

```
.onUnload <- function (libpath) {
  library.dynam.unload("mypackage", libpath)
}
```
