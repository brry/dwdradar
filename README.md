### dwdradar
read DWD binary radar files (RADOLAN).
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version-last-release/dwdradar)](https://cran.r-project.org/package=dwdradar) 
[![downloads](http://cranlogs.r-pkg.org/badges/dwdradar)](https://www.r-pkg.org/services)
[![Rdoc](http://www.rdocumentation.org/badges/version/dwdradar)](https://www.rdocumentation.org/packages/dwdradar)

This is an auxiliary package to [rdwd](https://github.com/brry/rdwd#rdwd).  
`dwdradar` is used in some of the functions underlying `read.DWD()`, see the [raster chapter](https://bookdown.org/brry/rdwd/raster-data.html) in the documentation.

### Installation

*Regular:*
```R
install.packages("dwdradar")
```

*Latest version:*  
Note: on Windows, you need to have [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
installed directly at `C:/Rtools`  
(Compiler paths may not have spaces, as there would be with `C:/Program Files/R/Rtools/`).
```R
if(!requireNamespace("remotes", quietly=TRUE)) install.packages("remotes")
remotes::install_github("brry/dwdradar")
```
