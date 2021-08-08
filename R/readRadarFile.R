#' @title read binary radolan radar file
#' @description Read a single binary DWD Radolan file. To be used in \code{rdwd}.\cr
#'   If any files ar not read correctly, please let me know. So far, tests have
#'   only been conducted for some files. Optimally, check the
#'   Kompositformatbeschreibung at \url{https://www.dwd.de/DE/leistungen/radolan/radolan.html}
#'   and let me know what needs to be changed.
#'   The meta-info is extracted with \code{\link{readHeader}} (not exported, but documented)\cr
#'   Binary bits are converted to decimal numbers with Fortran routines, see
#'   \url{https://github.com/brry/dwdradar/tree/master/src}.
#'   They are called via \code{\link{bin2num}} (not exported, but documented).
#' @return Invisible list with \code{dat} (matrix) and \code{meta}
#' (list with elements from header, see Kompositformatbeschreibung)
#' @author Maintained by Berry Boessenkool, \email{berry-b@@gmx.de}, May + Oct 2019.\cr
#'   Original codebase by Henning Rust & Christoph Ritschel at FU Berlin
#' @keywords file binary
#' @useDynLib dwdradar, .registration=TRUE
#' @seealso real-world usage in \code{rdwd}: \url{https://bookdown.org/brry/rdwd/raster-data.html}
#' @export
#' @examples
#'
#' f <- system.file("extdata/raa01_sf_2019-10-14_1950", package="dwdradar")
#' out <- readRadarFile(f)
#' out$meta
#'
#' if(requireNamespace("raster", quietly=TRUE))
#'   raster::plot(raster::raster(out$dat))
#'
#' # for more files, see the tests.
#' # for real-world usage, readDWD.binary / readDWD.radar in the rdwd package
#'
#' @param binfile Name of a single binary file
#' @param na      Value to be set for missing data (bit 14). DEFAULT: NA
#' @param clutter Value to be set for clutter data (bit 16). DEFAULT: NA
#'
readRadarFile <- function(binfile, na=NA, clutter=NA)
{
finalOut <- try({
if(!file.exists(binfile)) stop("The following file does not exist: '", binfile, "'.")
openfile <- file(binfile,"rb") # will be read successively
on.exit(close(openfile), add=TRUE)

# read meta-info elements of the header:
h <- readHeader(binfile)

h_bin <- rawToChar(readBin(openfile, what=raw(), n=h$nchar, endian="little"))
# Check
stopifnot(h$header == sub("\003","",h_bin) ) # ToDo: check with nicer error message

# read the remaining binary data set:
DIM <- h$dim
LEN <- DIM[1]*DIM[2]
dat <- readBin(openfile, what=raw(), n=LEN*2, endian="little")

# convert into a two byte set and then into values with fortran routines:
if(h$product=="RX") # WX,EX? - currently handled like SF # ToDo: Test
  {
  dim(dat) <- c(1,LEN)
  dat.val <- bin2num(dat,LEN,na,clutter, RX=TRUE)
  dat.val <- dat.val/2 - 32.5
  }else
  # for SF, RW, RQ
  {
  dim(dat) <- c(2,LEN)
  dat.val <- bin2num(dat,LEN,na,clutter)
  }

# apply precision given in the header:
dat.val <- dat.val*h$precision

# convert into a matrix + give row and column names according to RADOLAN convention:
if(h$product=="RW" | h$product=="SF" | h$product=="RQ" | h$product=="YW")
  {
  dat.mat <- matrix(dat.val, ncol=DIM[2], byrow=TRUE) # ToDo: not sure about this
  dat.mat <- apply(dat.mat, 2, rev)
  dimnames(dat.mat) <- list(x.nrs=1:DIM[1]-1, y.nrs=1:DIM[2]-1) # ToDo: necessary? slow?
  }
else
  {
  dat.mat <- t(matrix(dat.val,DIM[1],DIM[2])) # i=lon, j=lat
  dimnames(dat.mat) <- list(x.nrs=1:DIM[2]-1, y.nrs=1:DIM[1]-1) # reversed because of t()
  }

# Output
return(list(dat=dat.mat, meta=h))
}, silent=TRUE) # end of try
if(inherits(finalOut,"try-error")) warning(finalOut, "in file: ", binfile, call.=FALSE)
return(invisible(finalOut))
}


