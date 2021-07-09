package-deps
============

A command-line utility to investigate the current purescript package-sets and to let you query package dependencies or paths between packages. The **deps** command gives either the immediate or the transitive dependencies of a package.  It also lets you pivot the package sets so as to reverse the dependencies and query the pivoted data in the same manner. The **paths** command gives all the paths that exist between two different packages.

querying the latest purescript package-sets 
-------------------------------------------

These commands query the [latest](https://raw.githubusercontent.com/purescript/package-sets/master/packages.json) packages.json file.

direct dependencies of a package

```
    ./pkg deps --package NAME
    ./pkg deps -p NAME
```

transitive dependencies of a package

```
    ./pkg deps --transitive --package NAME
    ./pkg deps -t -p NAME
```

all packages that themselves immediately depend on another package (by reversing the dependencies direction)

```
    ./pkg deps --reverse --package NAME
    ./pkg deps -r -p NAME
```


all packages that themselves transitively depend on another package 

```
    ./pkg deps --reverse --transitive --package NAME
    ./pkg deps -r -t -p NAME
```

all the paths that exist between two packages (forward direction)

```
    ./pkg paths --from NAME --to NAME
    ./pkg paths -f NAME -t NAME
```

querying other package-sets 
---------------------------

Use the commands listed above, but override the default target package sets by supplying your preferred version by means of the ```--uri``` parameter.  For example:


```
    ./pkg deps --package NAME --uri https://github.com/myrepo/packages.json
    ./pkg deps -p NAME -u https://github.com/myrepo/packages.json
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

to run through spago
--------------------

you must use ```exec-args```, For example :

```
    spago run --exec-args "deps -r -t -p NAME"
```