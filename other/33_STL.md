# 標準 C++ アルゴリズム

標準 C++ の `<algorithm>` と `<numeric>` ヘッダファイルでは様々な汎用アルゴリズムが提供されています。イテレータの章でも述べたように、その多くでは、イテレータを使ってアルゴリズムを適用する位置や範囲を指定します。

下のコード例では `<algorithm>` ヘッダファイルにある `count()` 関数を用いて、ベクトルに対して指定した値と等しい要素の数を数える例を示します。

```
#include <algorithm>
// [[Rcpp::export]]
int rcpp_count(){
    // 文字列ベクトルの作成
    CharacterVector v =
        CharacterVector::create("A", "B", "A", "C", NA_STRING);

    // 文字列ベクトル v から値が "A" である要素の数を数えます
    return std::count(v.begin(), v.end(), "A"); // 2
}
```

なお、標準 C++ のクラスや関数などは `std::` 名前空間の中で定義されているため `std::vector` のように `std::` をつけて指定するか、 `using namespace std;` を記述して `std` 名前空間を利用するように指定します。