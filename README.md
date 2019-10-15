### dwdradar
read DWD binary radar files

### Installation

#### Normal
Note: this package is not on CRAN yet. It should be there soon, though.
```R
install.packages("dwdradar")
```

#### Latest version
Note: on Windows, you need to have [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
installed directly at `C:/Rtools`  
(Compiler paths may not have spaces, as there would be with `C:/Program Files/R/Rtools/`).
```R
if(!requireNamespace("remotes", quietly=TRUE)) install.packages("remotes")
remotes::install_github("brry/dwdradar")
```
