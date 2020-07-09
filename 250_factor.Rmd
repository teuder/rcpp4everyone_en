# factor

The factor vector (`factor`) is actually an integer vector with the attributes `levels` and `class` is defined.

In the code below, an example of converting integer vector to `factor` by setting values to attributes.


```
// Creating "factor"
// [[Rcpp::export]]
RObject rcpp_factor(){
  IntegerVector v = {1,2,3,1,2,3};
  CharacterVector ch = {"A","B","C"};
  v.attr("class") = "factor";
  v.attr("levels") = ch;
  return v;
}
```

The execution result below, we can see that the integer vector returned to R is treated as `factor`.

```
> rcpp_factor()
[1] A B C A B C
Levels: A B C
```
