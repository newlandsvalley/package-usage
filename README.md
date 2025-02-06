# package-deps

DEPRECATED - this functionality now exists in [spago@next](https://github.com/purescript/spago).

A command-line utility to investigate purescript package-sets and to let you query package dependencies or paths between packages. 

## Install

```
   npm install -g purs-pkg-deps
```

## Usage

The **deps** command gives either the immediate or the transitive dependencies of a package.  It also lets you pivot the package sets so as to reverse the dependencies and query the pivoted data in the same manner. The **paths** command gives all the paths that exist between two different packages.

### querying the latest purescript package-sets 

These commands show how you can query the [latest](https://raw.githubusercontent.com/purescript/package-sets/master/packages.json) packages.json file.


#### direct dependencies of a package

```
    purs-pkg-deps deps --package NAME
    purs-pkg-deps deps -p NAME
```

#### transitive dependencies of a package

```
    purs-pkg-deps deps --transitive --package NAME
    purs-pkg-deps deps -t -p NAME
```

#### all packages that themselves immediately depend on another package (by reversing the dependencies direction)

```
    purs-pkg-deps deps --reverse --package NAME
    purs-pkg-deps deps -r -p NAME
```

#### all packages that themselves transitively depend on another package 

```
    purs-pkg-deps deps --reverse --transitive --package NAME
    purs-pkg-deps deps -r -t -p NAME
```

#### all the paths that exist between two packages (forward direction)

```
    purs-pkg-deps paths --from NAME --to NAME
    purs-pkg-deps paths -f NAME -t NAME
```

### querying other package-sets 

Use the commands listed above, but override the default target package sets by supplying your preferred version by means of the ```--uri``` parameter.  For example:


```
    purs-pkg-deps deps --package NAME --uri https://github.com/myrepo/packages.json
    purs-pkg-deps deps -p NAME -u https://github.com/myrepo/packages.json
```

## Development

### prerequisites

   * Purs: 0.14
   * Spago: 0.20
   * npm: 14
   * xhr2: 0.2.1

### Running bin


```
   npm run build
   ./bin/index.js --help
```
