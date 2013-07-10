
# try this:
#csvCompare("tests/csvcompare/data1.csv","tests/csvcompare/data2.csv")

csvCompare <- function(data1, data2, outfile="datacompare.xlsx", colour="red", ...){

  
  r <- require(xlsx)
  if(!r)stop("Install the 'xlsx' package first!")
  
  if(is.character(data1) && file.exists(data1))
    data1 <- read.csv(data1, ...)
  if(is.character(data2) && file.exists(data2))
    data2 <- read.csv(data2, ...)

  d1 <- dim(data1)
  d2 <- dim(data2)
  
  
  if(d1[1] != d2[1])
    stop("Number of rows differs")
  if(d1[2] != d2[2])
    stop("Number of columns differs")

  P <- which(data1 != data2, TRUE)
  
  wb <- createWorkbook()
  
  fillstyle <- CellStyle(wb) + Fill(backgroundColor=colour, foregroundColor=colour,
                                    pattern="SOLID_FOREGROUND")
  
  sheet1  <- createSheet(wb, sheetName="data1")
  sheet2  <- createSheet(wb, sheetName="data2")
  ii <- 1
  nc <- ncol(data1)
  nr <- nrow(data1)
  
  rows1  <- createRow(sheet1, rowIndex=1:(nr+ii)) 
  rows2  <- createRow(sheet2, rowIndex=1:(nr+ii)) 
  
  writeData <- function(rows, dat, P){
    cells <- createCell(rows, colIndex = 1:nc)
    
    mapply(setCellValue, cells[1,1:nc], names(dat))
    
    for(i in 1:nr){  
      mapply(setCellValue, cells[i+ii,1:nc], dat[i,])
    }
  
    for(k in 1:nrow(P)){
      setCellStyle(cells[[P[k,1]+ii,P[k,2]]], fillstyle)
    }
    
  }
  writeData(rows1, data1, P)
  writeData(rows2, data2, P)
  
  saveWorkbook(wb, outfile)
  message("Results written to: ", outfile)
}
  
  
  
  
