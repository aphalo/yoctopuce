
# yoctopuce

<!-- badges: start -->

[![gginnards status
badge](https://aphalo.r-universe.dev/badges/yoctopuce)](https://aphalo.r-universe.dev/yoctopuce)
[![web
site](https://img.shields.io/badge/documentation-yoctopuce-informational.svg)](https://docs.r4photobiology.info/yoctopuce/)
<!-- badges: end -->

## Purpose

YoctoPuce produces isolated USB modules and special hubs suitable for
diverse automation tasks, including data acquisition and logging, and
various actuators suitable for control. YoctoPuce supplies libraries for
several computing languages but not for R. Using the *yoctopuce* Python
library from R is rather easy thanks to R package
[‘reticulate’](https://rstudio.github.io/reticulate/). R package
‘yoctopuce’ makes its easier for R users unfamiliar with package
‘reticulate’ and/or Python to use the library. Package ‘yoctopuce’ also
includes an article (published only as part of the online documentation)
with use case examples for diferent YoctoPuce USB modules.

## Use

If using a virtual hub instead of a hardware one, the [VirtualHub
software](https://www.yoctopuce.com/EN/virtualhub.php) should be
installed and running on the computer or microcontroller board where the
USB modules are plugged in.

``` r
library(yoctopuce)
```

Python and the Python ‘yoctopuce’ library have to be installed on the
computer where the R code will run. The library is installed in a
separate Python environment \`r-yoctopuce’, that is used only by R
package ‘yoctopuce’. This is to avoid interfering with other uses of
Python. Installation, of course, needs to be done only once.

``` r
install_python()
install_yoctopuce()
```

On each R session where communication with yoctopuce modules is needed,
the library needs to be imported and registered. Based on the module
being targeted we import functions to make them available in R and
register the hub (virtual or hardware) that will be used to connect to
the modules. The example below assumes we will use a YoctoRelay and a
YoctoMeteo module through a local virtual hub.

See the [library
documentation](https://www.yoctopuce.com/EN/doc/reference/yoctolib-php-EN.html)
for details. Be aware that the imports are done by `"function"`, not
module name. Say for both YoctoRelay and YoctoPowerRelay modules the
import is the same `yocto_relay`, while for YoctoMeteo with its
different “functions”, three imports are needed to be able to use all of
them. Additional imports would be needed to access the data logger built
into the YoctoMeteo module.

``` r
y_initialise("yocto_relay", "yocto_humidity", "yocto_temperature", "yocto_pressure")
ls(pattern = "^yocto")
```

This creates R objects `yocto_api`, `yocto_humidity`,
`yocto_temperature`, `yocto_pressure` giving access to the functions and
objects from the Python library using `$` notation. However, one needs
first to find the module one intends to use and create a wrapper object.
The serial number plus “function” name within the module or an
user-assigned name of the module “function”, is used to locate it. Here
we use `"RELAY1"`, the default name of the first of two relays
(“functions”) in the YoctoRelay module. When using default names, only
one module of a given type can be used. With multiple identical modules,
either names should be changed to unique ones, or serial numbers used.
Using default names makes the code usable unchanged with any YoctoPuce
module of a given type, while using different names or serial numbers
makes it possible to individually access multiple modules of the same
type through the same hub.

``` r
Relay1 <- yocto_relay$YRelay$FindRelay("RELAY1")
# in case of failure the Python error message is displayed

# we can check the serial number of the found relay
Relay1$describe()
Relay1$get_functionId()

# We can then, for example, flip the relay switch to ON ("B") state for 200 ms
Relay1$pulse(200)
```

## YoctoPuce documentation

The [YoctoPuce website](https://www.yoctopuce.com/) provides many code
examples in module manuals, tutorials and in blog posts. The libraries
for different computer languages use consistent naming and design and
code examples not using the Python version of the library and easy to
translate.

## Package ‘reticulate’

Currently, package ‘reticulate’ is imported in whole and re-exported.
Thus, when package ‘yocotpuce’ is loaded and attached, package
‘reticulate’ is also loaded and attached. So, functions and objects from
‘reticulate’ can be accessed directly by their name, as shown above for
`install_phyton()`.

## Installation

Installation of the current unstable version from R-Universe CRAN-like
repository (binaries for Mac, Win, Webassembly, and Linux, as well as
sources available):

``` r
install.packages('yoctopuce', 
                 repos = c('https://aphalo.r-universe.dev', 
                           'https://cloud.r-project.org'))
```

Installation of the current unstable version from GitHub (from sources):

``` r
# install.packages("devtools")
devtools::install_github("aphalo/yoctopuce")
```

## Documentation

HTML documentation is available at
(<https://docs.r4photobiology.info/yoctopuce/>), including one vignette
and one article.

News about updates are regularly posted at
(<https://www.r4photobiology.info/>).

## Contributing

Please report bugs and request new features at
(<https://github.com/aphalo/yoctopuce/issues>). Pull requests are
welcome at (<https://github.com/aphalo/yoctopuce>).

## Citation

If you use this package to produce scientific or commercial
publications, please cite according to:

``` r
citation("yoctopuce")
#> To cite package 'yoctopuce' in publications use:
#> 
#>   Aphalo P (2024). _yoctopuce: YoctoPuce USB modules_. R package
#>   version 0.1.0, https://docs.r4photobiology.info/yoctopuce,
#>   <https://github.com/aphalo/yoctopuce>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {yoctopuce: YoctoPuce USB modules},
#>     author = {Pedro J. Aphalo},
#>     year = {2024},
#>     note = {R package version 0.1.0, https://docs.r4photobiology.info/yoctopuce},
#>     url = {https://github.com/aphalo/yoctopuce},
#>   }
```

## License

© 2024 Pedro J. Aphalo (<pedro.aphalo@helsinki.fi>). Released under the
GPL, version 2 or greater. This software carries no warranty of any
kind.
