library(seqinr)
library(reshape2)
library(writexl)
library(ggplot2)
#library(ape)
#library(igraph)
#library(ggnetwork)
#library(ggrepel)

files<-list.files( pattern = "Snippy_superclean.core.aln")
if(length(files)==0) files<- list.files( pattern = "SnippyResults.full_clean.aln")

if(length(files)==1){
  fastas<-read.fasta(files)
  distmat<-as.data.frame(matrix(NA, ncol = length(fastas), nrow = length(fastas)))
  colnames(distmat)<-names(fastas)
  rownames(distmat)<-names(fastas)
  pb<-txtProgressBar(max = nrow(distmat)*ncol(distmat))
  counter<-0
  for (i in 1:nrow(distmat)) {
    for (j in 1:ncol(distmat)) {
      counter<-counter+1
      setTxtProgressBar(pb, counter)
      distmat[i,j]<-length(which(unlist(fastas[which(names(fastas)==row.names(distmat)[i])])!= 
                                   unlist(fastas[which(names(fastas)==row.names(distmat)[j])])))
    }
  }
  distmat$rn <- row.names(distmat)
  distmat.melt<-melt(distmat, id.vars ="rn"  )
  colnames(distmat.melt)<-c("Sample1", "Sample2", "SNPdistance")
  present<-vector()
  to.del<-vector()
  for (i in 1:nrow(distmat.melt)) {
    if(length(which(paste(distmat.melt$Sample1[i], distmat.melt$Sample2[i]) %in% present)) ==1){
      to.del<-c(to.del, i)
    }else{
      present<-c(present, paste(distmat.melt$Sample2[i], distmat.melt$Sample1[i]))
    }
  }
  distmat.melt<-distmat.melt[-to.del,]
  
  ggplot(distmat.melt)+
    geom_tile(aes(Sample1, Sample2, fill=SNPdistance))+
    scale_fill_gradient(low = "red", high = "blue")+
    geom_text(aes(Sample1, Sample2, label=SNPdistance))+
    theme_minimal()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  ggsave("SNPdistancePlot.pdf", height = 8.27, width =11.69)
  write_xlsx(distmat.melt, "SNPdistancesPairs.xlsx")

}


# distmat$rn<-NULL
# MST<- ape::mst(distmat)
# 
# gr.undir = graph.adjacency(as.matrix(MST), mode = "undirected")
# graph.undir = ggnetwork(gr.undir, arrow.gap = 0)
# 
# close.contacts<- distmat.melt[which(distmat.melt$SNPdistance<60),]
# 
# graph.undir$CloseContact<-"NO"
# graph.undir$Pivot<-paste(graph.undir$xend, graph.undir$yend)
# graph.undir$name_end<- graph.undir$name[match(graph.undir$Pivot, paste(graph.undir$x, graph.undir$y))]
# 
# graph.undir$CloseContact[which(graph.undir$name)]
# 
# close.match<-c(paste(close.contacts$Sample1, close.contacts$Sample2), paste(close.contacts$Sample2, close.contacts$Sample1))
# 
# graph.undir$yend[which(paste(graph.undir$name, graph.undir$name_end) %in% close.match) ]<- 
#   graph.undir$y[which(paste(graph.undir$name, graph.undir$name_end) %in% close.match) ]
# 
# graph.undir$xend[which(paste(graph.undir$name, graph.undir$name_end) %in% close.match) ]<- 
#   graph.undir$x[which(paste(graph.undir$name, graph.undir$name_end) %in% close.match) ]
# 
# graph.undir$CloseContact[which(paste(graph.undir$name, graph.undir$name_end) %in% close.match)]<-"YES"
# graph.undir$CloseContact[which(graph.undir$name == graph.undir$name_end)]<-"NO"
# 
# ggplot(graph.undir, aes(x = x, y = y, xend = xend, yend = yend)) +
#                   geom_edges(color = "black", alpha = 0.2, curvature = 0) +
#                   geom_nodes(  alpha=0.3)+
#   geom_text_repel(data=graph.undir[which(graph.undir$CloseContact=="YES"),], aes(x,y,label=name))+
#                   #  geom_text(data=labs,aes(xend, yend, label=sample))+
#                   theme_minimal()
