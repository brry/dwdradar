#' @title binary to numeric
#' @description Call FORTRAN routines
#' @return numerical vector
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, May + Oct 2019
#' @seealso \code{\link{readRadarFile}}
#' @keywords file
#' @export
#'
#' @param dat      Binary data returned by \code{\link{readBin}}
#' @param len      Length of data.
#' @param na       Value to be set for missing data (bit 14). DEFAULT: NA
#' @param clutter  Value to be set for clutter data (bit 16). DEFAULT: NA
#' @param RX       Logical: call rx routine? DEFAULT: FALSE
#'
bin2num <- function(dat, len, na=NA, clutter=NA, RX=FALSE)
{
Fna <- -32767L
Fclutter <- -32766L
if(RX) {
  na <- (na+32.5)*2
  clutter <- (clutter+32.5)*2
  out <- .Fortran("binary_to_num_rx", raw=dat, Flength=as.integer(len),
                numeric=as.integer(array(0,dim=len)), Fna=Fna, Fclutter=Fclutter)
  }
else
out <- .Fortran("binary_to_num", raw=dat, Flength=as.integer(len),
                numeric=as.integer(array(0,dim=len)), Fna=Fna, Fclutter=Fclutter)
out <- out$numeric
out[out==Fna] <- na
out[out==Fclutter] <- clutter
return(out)
}





# pure R version kept for reference ----

if(FALSE){
# Pure R version:  700 ms per file
# Fortran Version:  55 ms per file
bits <- matrix(rawToBits(dat), ncol=16, byrow=TRUE) # bits 1-12: data
b2n <- function(i) as.numeric(bits[,i])*2^(i-1)
val <- b2n(1)+b2n(2)+b2n(3)+b2n(4)+b2n(5)+b2n(6)+b2n(7)+b2n(8)+b2n(9)+b2n(10)+b2n(11)+b2n(12)
#                                       # bit 13: flag for interpolated
val[bits[,14]==1] <- na                 # bit 14: flag for missing
val[bits[,15]==1] <- -val[bits[,15]==1] # bit 15: flag for negative
val[bits[,16]==1] <- clutter            # bit 16: flag for clutter
return(as.integer(val))

#system.time(r <- readRadarFile("raa01-rx_10000-1605290600-dwd---bin_Braunsbach", clutter=NA))
#raster::plot(raster::raster(r$dat))
#mb <- microbenchmark::microbenchmark(readRadarFile("raa01-rx_10000-1605290600-dwd---bin_Braunsbach"))
}
