setwd("C:/Users/jgw_x/Desktop/XBRL/上市/XBRL")
library(XBRL)
library(tmcn)
library(sqldf)
library(tm)

inst <- "tifrs-fr0-m1-ci-cr-1437-2013Q4.xml"
doc <- xbrlParse(inst)
fct <- xbrlProcessFacts(doc) #get a data frame with facts 
fct2 <- as.data.frame(toUTF8(fct[1:809,"elementId"]))
fct3 <- as.data.frame(toUTF8(fct[1:809,"fact"]))
fct4 <- as.data.frame(cbind(fct2,fct3))
names(fct4) <- c("elementId","fact")
accountreport2 <- sqldf("select fact from fct4 where elementId = 'tifrs-ar_AccountantsReportBody'")
accountreport2$fact <- gsub('\\s+', '',accountreport2$fact)
nch <- as.data.frame(sqldf("select fact from fct4 where elementId = 'tifrs-notes_Year'"))
accountreport2 <-as.data.frame(cbind(accountreport2,nch))
names(accountreport2) <- c("fct","year")




dir.list <- list.files("C:/Users/jgw_x/Desktop/XBRL/上市/XBRL")
a <- 2
for ( a in c(2:1500))
{
  inst <- dir.list[a]
  doc <- xbrlParse(inst)
  fct <- xbrlProcessFacts(doc)
  fct2 <- as.data.frame(toUTF8(fct[1:8000,"elementId"]))
  fct3 <- as.data.frame(toUTF8(fct[1:8000,"fact"]))
  fct4 <- as.data.frame(cbind(fct2,fct3))
  names(fct4) <- c("elementId","fact")
  accountreport <- sqldf("select fact from fct4 where elementId = 'tifrs-ar_AccountantsReportBody'")
  accountreport$fact <- gsub('\\s+', '',accountreport$fact)
  
  nch <- as.data.frame(sqldf("select fact from fct4 where elementId = 'tifrs-notes_Year'"))
  accountreport <-as.data.frame(cbind(accountreport,nch))
  names(accountreport) <- c("fct","year") 
  accountreport2 <- rbind(accountreport2,accountreport)
  
}


library(jiebaR)
cutter = worker(type="mix",bylines = T)
accountreport3 <- cutter[accountreport2$fct]
accountreport3 <- unlist(accountreport3)
freqdata <- freq(accountreport3)

write.csv(freqdata,file = "C:/Users/jgw_x/Desktop/論文rebuild/程式/paperrebuild/trydata.csv")
