paper2acc <- function(paper,prefixes=c("PRJE[A-Z]","PRJN[A-Z]","PRJD[A-Z]","ERP", "DRP", "SRP", 
                                       "SAME[A-Z]?","SAMD[A-Z]?", "SAMN[A-Z]?", "DRS", "SRS", "ERS", 
                                       "ERX", "DRX", "SRX", 
                                       "ERR","DRR", "SRR", "ERZ", "DRZ", "SRZ")){
  require(pdftools)
  require(stringr)
  txt <- pdf_text(paper)
  pats <- paste(paste0(prefixes,"[0-9\n-]+"),collapse="|",sep="|")
  pages <- grep(pats,txt,value=T)
  if(length(pages)>0){
    txtpat <- gsub("-$","",gsub("\n","",unlist(stringr::str_extract_all(pages,pattern = pats))))
    accpre <- gsub("[^[:digit:]-]+([[:digit:]-]+)","\\1",gsub("-+","-",grep("[^[:digit:]]-",txtpat,invert=T,value=T)))
    accsuf <- gsub("([^[:digit:]-]+)[[:digit:]-]+","\\1",gsub("-+","-",grep("[^[:digit:]]-",txtpat,invert=T,value=T)))
    o <- unique(c(unlist(sapply(1:length(accpre),
                  function(x){
                    if(grepl("-",accpre[x])){
                      hyphpart <- unlist(strsplit(accpre[x],"-"))
                      sprintf(paste0(accsuf[x],"%0",nchar(unlist(strsplit(accpre[x],"-"))[1]),"d"),
                              c(unlist(strsplit(accpre[x],"-"))[1]:paste0(substr(hyphpart[1],1,
                                                                                 nchar(hyphpart[1])-nchar(hyphpart[2])),
                                                                          hyphpart[2])))
                    }else{
                      paste0(accsuf[x],accpre[x])
                    }}))))
  }else{
    warning(paste0("No accession found in ",paper,"."))
    o <- NULL
  }
  grep("[^[:digit:]][[:digit:]]",o,value=T)
}
acc2runtable <- function(acc){
  require(rentrez)
  library(data.table)
  if(length(acc)>1){
  as.data.frame(rbindlist(sapply(acc,function(x){
    as.data.frame(fread(entrez_fetch(id = entrez_search(db="sra",term=x),db="sra",rettype = "runinfo")),stringsAsFactors=F)
  },simplify = F)),stringsAsFactors=F)
  }else{
    as.data.frame(fread(entrez_fetch(id = entrez_search(db="sra",term=acc),db="sra",rettype = "runinfo")),stringsAsFactors=F)
  }
}



biosample2sampledata <- function(acc){
  l <- xmlToList(entrez_fetch(id = entrez_search(db="biosample",term=acc),db="biosample",
                                rettype="full"))
  v <- sapply(l$BioSample$Attributes,function(x){
    y <- x[[1]]
    names(y) <- x[[2]][[1]]
    y
    })
  names(v) <- gsub("^Attribute.","",names(v))
  v
}

