# Cautions in handling Rcpp objects

### Assigning between vectors

When you assign a object `v1` to another object `v2` using `=` operator (`v2 = v1;`), the value of elements  of `v1` is not copied to `v2` but `v2` will be an alias to `v1`. Thus, if you change the value of some elements in `v1`, the change also applied to `v2`. You should use `clone()`, if you want to avoid coupling between objects (see sample code below).

The sample code presented below shows that the difference of the shallow copy and deep copy when you change value of one of vector after assigning.

```cpp
NumericVector v1 = {1,2,3};   // create a vector v1
NumericVector v2 = v1;        // v1 is assigned to v2 through shallow copy.
NumericVector v3 = clone(v1); // v1 is assigned to v3 through deep copy.

v1[0] = 100; // changing value of a element of v1

// Following output shows that
// the modification of v1 element
// is also applied to v2 but not to v3
Rcout << "v1 = " << v1 << endl; // 100 2 3
Rcout << "v2 = " << v2 << endl; // 100 2 3
Rcout << "v3 = " << v3 << endl; // 1 2 3
```
As explanation for people who have deeper knowledge of C++, a Rcpp object do not have value of R object (e.g. elements of a vector) itself, but have a pointer to R object. Thus, if you assign object through `v2 = v1;`, the value of pointer of `v1` is copied to `v2`. So, both `v1` and `v2` would be pointing to the same R object. This is called as "shallow copy". On the other hand, if you assign object through `v2 = clone(v1);`, the value of R object that `v1` is pointing is copied to `v2` as new R object. This is called "deep copy".



### Data type of numerical index

Maximum number of vector elements is limited to the length of 2^31 - 1 in R <= version 2.0.0 or 32 bit build of R, because `int` is used as data type of numerical index. However, long vector is supported after 64 bit build of R 3.0.0. You should use `R_xlen_t` as data data type for numerical index or the number of elements to support long vector in your Rcpp code.

```cpp
// Declare the number of element "n" using R_xlen_t
R_xlen_t n = v.length();
double sum = 0;
// Declare the numerical index "i" using R_xlen_t
for(R_xlen_t i=0; i<n; ++i){
  sum += v[i];
}
```



### Return type of operator[]

When you access to vector elements using `[]` or `()` operator, the return type is not `Vector` itself but `Vector::Proxy`. Thus, it will cause compile error when you pass `v[i]` directly to some function, if the function only supports `Vector` type. To avoid compile error `v[i]` assign to new object or convert it to type `T` using `as<T>()`.


```cpp
NumericVector v {1,2,3,4,5};
IntegerVector i {1,3};

// Compile error
//double x1 = sum(v[i]);

// Save as new object
NumericVector vi = v[i];
double   x2 = sum(vi);

// Convert to NumericVector using as<T>()
double   x3 = sum(as<NumericVector>(v[i]));
```
