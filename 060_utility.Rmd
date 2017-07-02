# Printing messages

You can print messages and values of objects on R console screen by using `Rprintf()` and `Rcout`.

`REprintf()` and `Rcerr` can be used for printing error messages.

## Rcout, Rcerr

The way of using `Rcout` and `Rcerr` is same as `std::cout` and `std::cerr`. Connecting messages or variables with `<<` in the order you want. When you give vector object to `<<`, it will print all the elements of the vector.

```cpp
// [[Rcpp::export]]
void rcpp_rcout(NumericVector v){
  // printing value of vector
  Rcout << "The value of v : " << v << "\n";

  // printing error message
  Rcerr << "Error message\n";
}
```

## Rprintf(), REprintf()

The way of using `Rprintf()` and `REprintf()` is same as `std::printf()`, it print message by specifying format.

```cpp
Rprintf( format, variables)
```
In the `format` string, you can use following format specifiers for printing the values of variables. When you want to print multiple variables, you have to pass these variables in the order that its corresponding specifier appears in the format string.

Only a part of format specifier is presented below, please refer to other documentation for detail (For example, [cplusplus.com](http://www.cplusplus.com/reference/cstdio/printf/)).

|specifier|explanation|
|:---:|---|
|`%i`| printing signed integer (`int`)|
|`%u`| printing unsigned integer (`unsigned int`)|
|`%f`| printing floating point number (`double`)|
|`%e`| printing floating point number (`double`) in exponential style|
|`%s`| printing C string (`char*`)|

Additionally, `Rprintf()` and `REprintf()` can only print data types that exist in standard C language, thus you cannot pass data types defined by Rcpp package (such as `NumericVector`) to `Rprintf()` directly. If you want to print the values of elements of Rcpp vector using `Rprintf()`, you have to pass each element separately to it (see below).

```cpp
// [[Rcpp::export]]
void rcpp_rprintf(NumericVector v){
    // printing values of all the elements of Rcpp vector  
    for(int i=0; i<v.length(); ++i){
        Rprintf("the value of v[%i] : %f \n", i, v[i]);
    }
}
```
