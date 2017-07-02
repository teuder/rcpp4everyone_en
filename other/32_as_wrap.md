# 標準 C++ のデータ構造を利用する

標準 C++ では `vector` `list` `map` `set` などの様々なデータ構造（コンテナ）が提供されています。それらはデータへのアクセス・追加・削除などの効率が異なるので、目的に応じて使い分けることで、実現したい処理をより効率よく実装できる場合があります。

例えば、ベクトルに要素を追加する処理を例にすると、Rcpp の `Rcpp::Vector` と標準 C++ の `std::vector` には、どちらにもベクトルの末尾に要素を追加するメンバ関数 `push_back()` が提供されていますが、その処理効率には大きな違いがあります。なぜなら `Rcpp::Vector` では `push_back()` メンバ関数を実行する度に追加した値を含むベクトル全体の値をメモリ上の他の場所にコピーする処理が発生するのに対して、`std::vector` では多くの場合には全体のコピーを行うことなく末尾に要素を追加することができるためです。

下に、`std::vector` を用いた例として、行列の要素の値が 0 ではない要素の行番号と列番号を取得する例を示します。

```cpp
// [[Rcpp::export]]
DataFrame matix_rows_cols(NumericMatrix m){
    // 行列から値が 0 ではない要素の列番号と行番号を返します。
    // 簡単のため行列は NA を含まない前提とします。

    // 行数 I 、列数 J
    int I = m.rows();
    int J = m.cols();

    // 結果を標準 C++ コンテナの vector に格納します。
    std::vector<int> rows, cols; //行番号と列番号を格納する変数

    // 要素の数は最大で行列 m の要素数になり得るので
    // その分のメモリを先に確保します。
    rows.reserve(m.length());
    cols.reserve(m.length());

    // 行列 m の全ての要素にアクセスして
    // 値が 0 ではない要素の行番号と列番号を保存します。
    for(int i=0; i<I; ++i){
        for(int j=0; j<J; ++j){
            if(m(i,j)!=0.0){
                rows.push_back(i+1);
                cols.push_back(j+1);
            }
        }
    }

    // 結果をデータフレームとして返します。
    return DataFrame::create(Named("rows", rows),
                             Named("cols", cols));
}
```

下に、いくつかの主要な標準 C++ データ構造の概要を示します。

|標準 C++ データ構造|概要|
|:-:|:---|
| `vector` |可変長配列：各要素はメモリ上で連続して配置されます。|
| `list`  |可変長配列：各要素はメモリ上で分散して配置されます。|
| `map`, `unordered_map` | 連想配列：キー・バリュー形式でデータを保持します。|
| `set`, `unordered_set` | 集合：重複のない値の集合を保持します。|

`map` は要素がキーの値でソートされた順に並びます。それに対して `unordered_map` では順番は保証されませんが要素の挿入とアクセスの速度に優ります。同様に、`set` は要素の値でソートされた順に並びます。`unordered_set` では順番は保証されませんが要素の挿入とアクセスの速度に優ります。


## 標準 C++ データ構造と Rcpp データ構造の変換

Rcpp のデータ構造と標準 C++ のデータ構造の変換には　`as<T>()` 関数と `wrap()` 関数を用います。

* `as<CPP>(RCPP)`   : Rcpp データ構造（RCPP）を標準 C++ データ構造（CPP）に変換します
* `wrap(CPP)` : 標準 C++ データ構造（CPP）を Rcpp データ構造に変換します

下表に Rcpp と標準 C++ で変換可能なデータ構造の対応を示します。（`+` は対応している、`-` 対応していないことを示しています。）

| Rcpp | 標準 C++ | as | wrap |
|:---:|:---:|:---:| :---: |
| `Vector` | `vector`, `list`, `deque`   |+|+|
| `List`, `DataFrame` | `vector<vector>`, `list<vector>` など|+|+|
|  名前付き `Vector` | `map`, `unordered_map`|-|+|
| `Vector` | `set`, `unordered_set`|-|+|

次のコード例では、Rcpp の `Vector` と標準 C++ のシーケンス・コンテナ（ `vector`, `list`, `deque` など値が直列に並んでいるように扱えるコンテナ）を変換する例を示します。

```cpp
NumericVector   rcpp_vector = {1,2,3,4,5};

// Rcpp::Vector から std::vector への変換  
std::vector<double>  cpp_vector = as< std::vector<double> >(rcpp_vector);

// std::vector から Rcpp::Vector への変換  
NumericVector v1 = wrap(cpp_vector);
```

次のコード例では、標準 C++ のシーケンス・コンテナが入れ子になった2次元コンテナを `DataFrame` や `List` に変換する例を示します。

```cpp
//
using namespace std;

// 要素となるベクトルの長さが全て等しい２次元ベクトルは
// DataFrame に変換できます
vector<vector<double>> cpp_vector_2d_01 = {{1,2},{3,4}};
DataFrame df = wrap(cpp_vector_2d_01);

// 要素となるベクトルの長さが異なる２次元ベクトルは
// List に変換できます
vector<vector<double>> cpp_vector_2d_02 = {{1,2},{3,4,5}};
List li = wrap(cpp_vector_2d_02);
```

次のコード例では、標準 C++ の `map<key, value>` と `unordered_map<key, value>` は `key` を要素の名前、`value` を要素の型とした、名前付き Vector に変換されることを示します。

```cpp
#include<map>
// [[Rcpp::export]]
NumericVector std_map(){
    std::map<std::string, double> cpp_num_map;
    cpp_num_map["C"] = 3;    
    cpp_num_map["B"] = 2;
    cpp_num_map["A"] = 1;

    std::un<std::string, double> cpp_num_map;
    cpp_num_map["C"] = 3;    
    cpp_num_map["B"] = 2;
    cpp_num_map["A"] = 1;

    Listli li = List::create(cpp_num_map, cpp_num_map);
}
```

実行結果

`std::map` ではキーの値でソートされているのに対して、`std::unordered_map` では順番が保証されないことがわかります。

```
> std_map()
[[1]]
A B C
2 1 3

[[2]]
A C B
2 3 1
```



## 標準 C++ データ構造を関数の引数や返値にする

`as()` 関数や　`wrap()` 関数で変換可能な標準 C++ データ構造は Rcpp 関数の引数や返値にすることもできます。そこでは R から Rcpp で記述した関数に値が渡される時、暗黙的に `as()` が呼ばれ、関数の返値が R に戻されるときには暗黙的に wrap() が呼ばれてデータが変換されます。

```cpp
// [[Rcpp::plugins("cpp11")]]
// [[Rcpp::export]]
vector<double> times_two_std_vector(vector<double> v){ //暗黙的に as() が呼ばれる
    for(double &x : v){
        x *= 2;
    }
    return v; //暗黙的に wrap() が呼ばれる
}
```