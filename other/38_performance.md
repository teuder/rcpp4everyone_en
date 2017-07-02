#パフォーマンス比較

RとRcppで記述した関数の実行速度を比較してみる。

**例：ギブス・サンプラー**

http://gallery.rcpp.org/articles/gibbs-sampler/

この例では、２重の for ループの中で乱数を生成し、結果を行列に格納しています。


**Rバージョン**

```r
gibbsR <- function(N,thin){

  mat<-matrix(0,nrow=N,ncol=2)
  x <- 0
  y <- 0

  for(i in 1:N){
    for(j in 1:thin){
      x <- rgamma(1, 3, 1/(y*y+4))
      y <- rnorm(1, 1/(x+1), 1/sqrt(2*x+2))
    }
    mat[i,] <- c(x,y)
  }
  return(mat)
}
```


**Rcppバージョン**

以下のコードを "gibbs.cpp" というファイル名で保存します。

```cpp
//gibbs.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix gibbsCpp(int N, int thin) {

  NumericMatrix mat(N, 2);
  double x = 0, y = 0;

  for(int i = 0; i < N; i++) {
    for(int j = 0; j < thin; j++) {
      x = R::rgamma(3.0, 1.0 / (y * y + 4));
      y = R::rnorm(1.0 / (x + 1), 1.0 / sqrt(2 * x + 2));
    }
    mat(i, 0) = x;
    mat(i, 1) = y;
  }

  return(mat);
}
```



**コンパイル & 実行**

```r
library(Rcpp)
sourceCpp('gibbs.cpp')
gibbsCpp(100, 10)
```



**R との比較**


RバージョンとRcppバージョンの関数の実行速度を比較してみる。その結果、Rcpp の方が56倍高速に実行されています。

この例のように、ベクターや行列の各要素への逐次アクセスするような場合に、Rcpp のアドバンテージが大きい。

```r
library(rbenchmark)
n <- 2000
thn <- 200
benchmark( gibbsR(n, thn),
           gibbsCpp(n, thn),
           columns = c("test", "replications", "elapsed", "relative"),
           order="relative",
           replications=10)
```
実行結果
```
test  replications elapsed relative
   2     gibbsCpp(n, thn)           10   1.454    1.000
   1       gibbsR(n, thn)           10  81.427   56.002
```
