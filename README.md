package-deps
============

A command-line utility to investigate the current purescript package-sets and to let you query package dependencies or paths between packages. The **deps** command gives either the immediate or the transitive dependencies of a package.  It also lets you pivot the package sets so as to reverse the dependencies and query the pivoted data in the same manner. The **paths** command gives all the paths that exist between two different packages.

querying the latest purescript package-sets 
-------------------------------------------

These commands query the [latest](https://raw.githubusercontent.com/purescript/package-sets/master/packages.json) packages.json file.

Firstly build the binary and then cd to the ```bin``` directory.

direct dependencies of a package

```
    node index deps --package NAME
    node index deps -p NAME
```

transitive dependencies of a package

```
    node index deps --transitive --package NAME
    node index deps -t -p NAME
```

all packages that themselves immediately depend on another package (by reversing the dependencies direction)

```
    node index deps --reverse --package NAME
    node index deps -r -p NAME
```


all packages that themselves transitively depend on another package 

```
    node index deps --reverse --transitive --package NAME
    node index deps -r -t -p NAME
```

all the paths that exist between two packages (forward direction)

```
    node index paths --from NAME --to NAME
    node index paths -f NAME -t NAME
```

querying other package-sets 
---------------------------

Use the commands listed above, but override the default target package sets by supplying your preferred version by means of the ```--uri``` parameter.  For example:


```
    node index deps --package NAME --uri https://github.com/myrepo/packages.json
    node index deps -p NAME -u https://github.com/myrepo/packages.json
```

prerequisites
-------------

```
   npm install xhr2
```


to build the binary
-------------------

```
   npm run build
```
