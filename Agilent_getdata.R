getdata<-function(){
  #from each .gpr file in a directory
  fileslist<-list.files(pattern="*.gpr",all.files=TRUE)
  end<-length(fileslist)
  columnnames<-character()
  mydata<-numeric()
  allchips<-1:end
  #reads the chip data
  #and separates data by block
  #there will always be 8 blocks in each chip
  blocks=1:8
  #reads RefNumber
  #into a new data frame to store all iterated data in later
  #initial<-readGAL(fileslist[1],path=NULL,header=TRUE,sep="\t",quote="\"",skip=NULL,as.is=TRUE)
  #initial_blockdata<-subset(initial,Block==1)
  #mydata<-data.frame(initial_blockdata$RefNumber)
  for (chip in allchips){
    chip_data<-readGAL(fileslist[chip],path=NULL,header=TRUE,sep="\t",quote="\"",skip=NULL,as.is=TRUE)
    chipname<-as.character(chip)
    for (b in blocks){
      blockname<-as.character(b)
      #in each block,
      #reads only columns with variable names:
      #F532.Median...B532,
      #Flags
      #Column
      #Row
      #Name
      #ID
      #RefNumber
      block_alldata<-subset(chip_data,Block==b)
      block_gooddata<-data.frame(block_alldata$RefNumber,block_alldata$ID,block_alldata$Name,block_alldata$Row,block_alldata$Column,block_alldata$Flags,block_alldata$F532.Median...B532)
      #find all occurences (iterate or search?):
      #Flags==-100
      #F532.Median...B532>=100
      #change F532.Median...B532 at corresponding row number == 1
      block_gooddata$block_alldata.F532.Median...B532[block_gooddata$block_alldata.F532.Median...B532>=100]<-1
      block_gooddata$block_alldata.F532.Median...B532[block_gooddata$block_alldata.Flags==-100]<-1
#check to make sure RefNumber matches before adding data into new data frame
      
      #store block_gooddata$block_alldata.F532.Median...B532 as new column in mydata matrix
      #so that the chip and block number info are new column head
      newcolumnhead<-paste("Block",blockname,"Chip",chipname)
      columnnames<-rbind(columnnames,newcolumnhead)
      sample_data<-c(block_gooddata$block_alldata.F532.Median...B532)
      mydata<-cbind(mydata,sample_data)
    }
  } 
  rownames(mydata)<-block_gooddata$block_alldata.RefNumber
  colnames(mydata)<-columnnames
  return(mydata)
}
