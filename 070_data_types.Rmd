# Data types

All the basic data types and data structures provided by R are available in Rcpp. By using these data types, you can directly access to the objects exist in R.

## Vector and Matrix

Following seven data types are often used in R.

`logical` `integer` `numeric` `complex` `character` `Date` `POSIXct`

There are vector type and matrix types in Rcpp corresponding to those of R.

In this document, the word `Vector` and `Matrix` is used to specify all the vector and matrix types in Rcpp.

The table below present the correspondence of data types between R/Rcpp/C++.

|Value | R vector|Rcpp vector|Rcpp matrix|Rcpp scalar|C++ scalar|
|:---:|:---:|:---:|:---:|:---:|:---:|
|Logical|`logical`  |`LogicalVector`| `LogicalMatrix`| - |`bool`|
|Integer|`integer`  |`IntegerVector`|`IntegerMatrix`|-|`int`|
|Real|`numeric` |`NumericVector`|`NumericMatrix`|-|`double`|
|Complex|`complex`  |`ComplexVector`| `ComplexMatrix`|`Rcomplex`|`complex`|
|String|`character`|`CharacterVector` (`StringVector`)| `CharacterMatrix` (`StringMatrix`)|`String`|`string`|
|Date  |`Date`     |`DateVector`|-|`Date`|-|
|Datetime  |`POSIXct`  |`DatetimeVector`|-| `Datetime` | `time_t` |


## data.frame, list, S3, S4

Other than vector and matrix, There are several data structure in R such as data.frame, list, S3 class and S4 class. You can handle all of these data structuers in Rcpp.

|R|Rcpp|
|:---:|:---:|
|`data.frame`|`DataFrame`|
|`list`|`List`|
|S3 class|`List`|
|S4 class|`S4`|

In Rcpp, `Vector`, `DataFrame`, `List` are all implemented as kinds of vectors. Namely, `Vector` is a vector that its elements are scalar values, `DataFrame` is a vector that its elements are `Vector`s, `List` is a vector that its elements are any kinds of data types. Thus, `Vector`, `DataFrame`, `List` has many common member functions in Rcpp.


<!--
`Dataframe` は、様々な型のベクトルを要素として格納することができます。しかし、要素となる全てのベクトルの長さは等しいという制約があります。

`List` は、`Dataframe` や `List` を含む、どのような型のオブジェクトでも要素として持つことができます。要素となるベクトルの長さにも制限はありません。

S3 クラスは属性 `class` に独自の名前が設定されたリストですので、使い方は `List` と同様です。

S4 クラスはスロット（`slot`）と呼ばれる内部データを持っています。Rcpp の `S4` を用いることで R で定義した S4 クラスのオブジェクトの作成、および、スロットへのアクセスが可能になります。
-->
