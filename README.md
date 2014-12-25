```
$ mkdir -p data
$ ./bin/fetch_and_save_diabetes.ml
$ /path/to/ocaml_gpr.native -verbose -cmd train -model diabetes.model < data/diabetes.csv
```
