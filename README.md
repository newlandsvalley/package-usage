package-usage
=============

I was intrigued to discover which library packages are most commonly used by other libraries.  To the extent that library authors bother to add their library to [purescript package-sets](https://github.com/purescript/package-sets), then this can be established simply by pivoting the data within ```packages.json``` so that the dependencies are reversed.

This, then, is a simple utility that queries the current ```packages.json``` and produces ```package-use.json```.

prerequisites
-------------

   npm install xhr2


to build
--------

   spago build

to run
------

   spago run