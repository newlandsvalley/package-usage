package-deps
============

A command-line utility to investigate the current purescript package-sets and to let you query both the immediate and transitive dependencies of a package.  It also lets you pivot the package sets so as to reverse the dependencies and query the pivoted data in the same manner.

command line options
--------------------

Show the direct dependencies of the supplied package

```
    ./package-deps -package NAME
    ./package-deps -p NAME
```

Show the transitive dependencies of the supplied package

```
    ./package-deps -transitive -package NAME
    ./package-deps -t -p NAME
```

Show the packages that themselves immediately depend on the package with the supplied name by reversing the dependencies

```
    ./package-deps -reverse -package NAME
    ./package-deps -r -p NAME
```


Show the packages that themselves transitively depend on the package with the supplied name

```
    ./package-deps -reverse -transitive -package NAME
    ./package-deps -r -t -p NAME
```

Note, if you are invoking the utility via spago run, you must use ```exec-args```, For example :

```
spago run --exec-args "-r -t -p NAME"
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
    spago run --exec-args "-r -t -p NAME"
```