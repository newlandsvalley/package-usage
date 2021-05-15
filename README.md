package-deps
============

A command-line utility to investigate the current purescript package-sets and to let you query package dependencies or paths between packages. The **deps** command gives either the immediate or the transitive dependencies of a package.  It also lets you pivot the package sets so as to reverse the dependencies and query the pivoted data in the same manner. The **paths** command gives all the paths that exist between two different packages.

command line options
--------------------

direct dependencies of a package

```
    ./package-deps deps --package NAME
    ./package-deps deps -p NAME
```

transitive dependencies of a package

```
    ./package-deps deps --transitive --package NAME
    ./package-deps deps -t -p NAME
```

all packages that themselves immediately depend on another package (by reversing the dependencies direction)

```
    ./package-deps deps --reverse --package NAME
    ./package-deps deps -r -p NAME
```


all packages that themselves transitively depend on another package 

```
    ./package-deps deps --reverse --transitive --package NAME
    ./package-deps deps -r -t -p NAME
```

all the paths that exist between two packages (forward direction)

```
    ./package-deps paths --from NAME --to NAME
    ./package-deps paths -f NAME -t NAME
```


prerequisites
-------------

```
   npm install xhr2
```


to build
--------

```
   spago build
```

to run throuh spago
-------------------

you must use ```exec-args```, For example :

```
    spago run --exec-args "deps -r -t -p NAME"
```