#' @title Read header part of binary DWD files
#' @description Read and process header of binary radar files
#' @return List with original string, nchar, derived information
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2020
#' @seealso Used in \code{\link{readRadarFile}}
#' @keywords file binary
# @importFrom package fun1 fun2
# @export # I currently think I'll keep it internal.
#' @examples
#' # See readRadarFile
#'
#' @param file Name of a single binary file
#'
readHeader <- function(file)
{
o <- scan(file, what="", n=1, sep="\003", quiet=TRUE) # Ended by ETX (\003)
out <- list()
out$filename <- file
out$header <- o # o for original header
out$nchar <- nchar(o) + 1 # +1 for ETX

DDHHMI              <- substr(o,  3,  8)
MOYY                <- substr(o, 14, 17)
out$date <- strptime(paste0(DDHHMI,"00-",MOYY), format="%d%H%M%S-%m%y")
out$product         <- substr(o,  1,  2)
out$location        <- substr(o,  9, 13) # "10000"
out$radius_format   <- substr(o, 29, 30) # " 3"
out$radolan_version <- substr(o, 35, 41) # e.g. " 2.18.3"
PREC                <- substr(o, 45, 48) # precision, e.g. E-01
INT                 <- substr(o, 52, 55) # interval, e.g. 5/60/1440
out$precision <- as.numeric(paste0("1", PREC)) # "E-01" to 0.1
out$interval_minutes <- as.numeric(INT)

DIM <- strsplit(o, "GP", fixed=TRUE)[[1]][2] # part after "GP"
DIM <- substr(DIM, 1, 9)
DIM1 <- as.numeric(unlist(strsplit(DIM,"x"))) # " 900x 900" to c(900,900)
if( any(is.na(DIM1)) | length(DIM1)!=2 )
  stop("Dimension (",DIM1[1],",",DIM1[2],") not correctly identified from header (",DIM,")!" )
out$dim <- DIM1

# Radarstandortkuerzel (boo, ros, emd, ...)
RADS <- strsplit(o, "<")[[1]][-1]           # parts after "<"
RADS <- sapply(strsplit(RADS, ">"), "[", 1) # parts before ">"
out$radars <- RADS[1]
out$radarn <- RADS[2] # for SF product, else NA

return(out)
}






# reference ----

if(FALSE){ # don't execute this - for reference only

f <- dir("tests", full=T)
f <- f[!grepl("gz$",f)]
f <- f[!grepl("testthat$",f)]
f <- f[!grepl("testthat.R$",f)]
f

readHeader(f[1])

h <- lapply(f, readHeader)
h

h <- unlist(sapply(h, "[", 2))
cat(h, sep="\n") # output copypasted below at 2020-02-12

# Original spacing:
"
12345678901234567
RW010950100000719BY1620149VS 3SW   2.21.0PR E-01INT  60GP 900x 900MF 00000001MS 66<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,oft,eis,tur,isn,fbg,mem>
RW311350100000719BY1620153VS 3SW   2.21.0PR E-01INT  60GP 900x 900MF 00000001MS 70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RW141450100001019BY1620153VS 3SW   2.21.0PR E-01INT  60GP 900x 900MF 00000001MS 70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RW310850100001217BY1980164VS 3SW   2.18.3PR E-01INT  60U0GP1100x 900MF 00000001VR2017.002MS 69<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RX290600100000516BY 810138VS 3SW   2.13.1PR E+00INT   5GP 900x 900MS 66<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,oft,eis,tur,isn,fbg,mem>
RY182355100001019BY1620142VS 3SW   2.21.0PR E-02INT   5GP 900x 900MS 70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
SF010450100000516BY1620267VS 3SW   2.13.1PR E-01INT1440GP 900x 900MS 70<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem> ST120<boo 24,drs 24,eis 24,emd 24,ess 24,fbg 24,fld 24,hnr 24,isn 24,mem 24,neu 24,nhb 24,oft 24,pro 24,ros 24,tur 24,umd 24>
SF141950100001019BY1620267VS 3SW   2.21.0PR E-01INT1440GP 900x 900MS 70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem> ST120<asb 24,boo 24,drs 24,eis 24,ess 24,fbg 24,fld 24,hnr 24,isn 24,mem 24,neu 24,nhb 24,oft 24,pro 24,ros 24,tur 24,umd 24>
RQ012030100000220BY1620166VS 3SW   2.28.0PR E-01INT  60GP 900x 900VV  60MF        8QN 000MS 70<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
RQ031845100000220BY1620166VS 3SW   2.28.0PR E-01INT  60GP 900x 900VV  60MF        8QN 001MS 70<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
RQ061900100000220BY1620166VS 3SW   2.28.0PR E-01INT  60GP 900x 900VV  60MF        8QN 001MS 71<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
"


# Spacing for human readability:
"
PD: product
DDHHMI: day hour minute
MOYY: month year
BYTELEN: lenght_bytes
RDVER: radolan_version
PREC: precision
INT: interval in minutes
GP dimension_nchar9
RL: length (nchar) of radar location information
ABBR: Radarstandortkuerzel
ST120: see RL + ABBR
12 34 56 78 90123 45 67
PD DD HH MI LOCAT MO YY BY BYTELEN VS3SW RADVER PR PREC INT MINU GPDIMENSION OTHER_STUFF_I_DONT_CARE RL ABBR
RW 01 09 50 10000 07 19 BY 1620149 VS3SW 2.21.0 PR E-01 INT   60 GP 900x 900 MF 00000001MS           66<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,oft,eis,tur,isn,fbg,mem>
RW 31 13 50 10000 07 19 BY 1620153 VS3SW 2.21.0 PR E-01 INT   60 GP 900x 900 MF 00000001MS           70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RW 14 14 50 10000 10 19 BY 1620153 VS3SW 2.21.0 PR E-01 INT   60 GP 900x 900 MF 00000001MS           70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RW 31 08 50 10000 12 17 BY 1980164 VS3SW 2.18.3 PR E-01 INT 60U0 GP1100x 900 MF 00000001VR2017.002MS 69<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
RX 29 06 00 10000 05 16 BY  810138 VS3SW 2.13.1 PR E+00 INT    5 GP 900x 900 MS                      66<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,oft,eis,tur,isn,fbg,mem>
RY 18 23 55 10000 10 19 BY 1620142 VS3SW 2.21.0 PR E-02 INT    5 GP 900x 900 MS                      70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem>
SF 01 04 50 10000 05 16 BY 1620267 VS3SW 2.13.1 PR E-01 INT 1440 GP 900x 900 MS                      70<boo,ros,emd,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem> ST120<boo 24,drs 24,eis 24,emd 24,ess 24,fbg 24,fld 24,hnr 24,isn 24,mem 24,neu 24,nhb 24,oft 24,pro 24,ros 24,tur 24,umd 24>
SF 14 19 50 10000 10 19 BY 1620267 VS3SW 2.21.0 PR E-01 INT 1440 GP 900x 900 MS                      70<asb,boo,ros,hnr,umd,pro,ess,fld,drs,neu,nhb,oft,eis,tur,isn,fbg,mem> ST120<asb 24,boo 24,drs 24,eis 24,ess 24,fbg 24,fld 24,hnr 24,isn 24,mem 24,neu 24,nhb 24,oft 24,pro 24,ros 24,tur 24,umd 24>
RQ 01 20 30 10000 02 20 BY 1620166 VS3SW 2.28.0 PR E-01 INT   60 GP 900x 900 VV  60MF      8QN 000MS 70<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
RQ 03 18 45 10000 02 20 BY 1620166 VS3SW 2.28.0 PR E-01 INT   60 GP 900x 900 VV  60MF      8QN 001MS 70<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
RQ 06 19 00 10000 02 20 BY 1620166 VS3SW 2.28.0 PR E-01 INT   60 GP 900x 900 VV  60MF      8QN 001MS 71<asb,boo,drs,eis,ess,fbg,fld,hnr,isn,mem,neu,nhb,oft,pro,ros,tur,umd>
"

}
