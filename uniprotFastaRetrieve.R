# phi46 uniprot Fasta Retrieve
#-uniprotFastaRetrieve.R----
#- all works ---
# Martin Urban
# 2018-04-04   
# input file: reads PhiSlim, PHIbase excel file
# output file: list of PHIbase Uniprot fasta sequences and IDs
#        takes Uniprot ids
#        sort and unique
#        retrieves fasta files from uniprots
library(tidyr) #for separate
library(data.table)
library(readr) #for fread on web 
library("dplyr") #for select, mutate

#library(readr)
setwd("H:/GoogleDrive/VIMdb/Projects/PHIbase/Phi45")


#======================================
#beneath change to tab file and df as there quite often are problems reading CSV
phiSlim=read.csv("phiSlim45_All.csv", header=TRUE, row.name=NULL,
                 check.names=FALSE, stringsAsFactors=FALSE)
#Alt-L for code folding
#some exploratory analysis on phiSlim data content
phiProtIds=phiSlim %>% select(ProtId) %>% distinct (ProtId)# %>% tally


getFasta=function(id){
  mydat <- readr::read_file(paste("http://www.uniprot.org/uniprot/", id,".fasta", sep=""))
  myseq=mydat %>% strsplit("\n") %>% unlist
  ID=myseq[[1]]
  protein=myseq[-c(1)]
  prot=paste(protein,collapse="")
  return (prot)
}

testFunction2 <- function (id) {
  return(tryCatch(getFasta(id), error=function(e) NA))
}

phi_prots=phiProtIds%>% rowwise() %>% mutate(Seq=testFunction2(ProtId))


#--write results--  # [_] Modify to write as tab
phi_prots %>% select(ProtId, Seq) %>% write.csv(file=paste("phi_proteins",Sys.Date(),".csv",sep=""))
pseqs=data.table::fread("phi_proteins2018-04-04.csv",select=c("ProtId","Seq"))
prot_missing = pseqs %>% filter(is.na(Seq)) 

all_prots=phi_prots %>% anti_join(prot_missing, by="ProtId")



prot_missing %>% select(ProtId, Seq) %>% write.csv(file=paste("phi_proteins_missing",Sys.Date(),".csv",sep=""))
phi_prots_missing=prot_missing%>% rowwise() %>% mutate(Seq=testFunction2(ProtId))

phi42_uniprots=data.table::fread("phi42_uniprot.csv",select=c("ProtId","Seq"))
test=phi_prots_missing %>% merge(phi42_uniprots, by="ProtId") %>% select(ProtId, Seq.y) %>% rename(Seq=Seq.y)

test %>% count
phi_prots_missing %>% count

prot_missing=merge(phi_prots_missing, test2) 


test3=phiSlim %>% merge(all_prots2, all.x=TRUE, all.y=FALSE) %>% arrange 
get_number<- function (x) gsub(pattern="^PHI:(.*)$", replacement= "\\1",perl=TRUE, x)
test4=test3 %>% mutate(number=get_number(PhiAcc))
                 
swap_last2first_col <- function (df) {
                   df=df[,c(ncol(df),1:(ncol(df)-1))]
}
test5=swap_last2first_col(test4)
test5$number=as.numeric(test5$number)
#sort on new number colum
test5=test5 %>%
        arrange(number)

test5 %>% write.csv(file=paste("phiSlimAndSeq_bak_",Sys.Date(),".csv",sep=""), row.names=FALSE, na="")


