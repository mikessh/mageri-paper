library(pROC); library(scales); library(iNEXT)

df <- read.table("summary.txt", header=T, sep ="\t")
df$qual <- as.numeric(as.character(df$qual))
df$freq<- as.numeric(as.character(df$freq))

### Figure 1

pdf("out/fig.2b.pdf")
df.1 <- subset(df, processing == "mageri")
rocobj1 <- plot.roc(df.1$type, df.1$qual,  percent=T, col="#fc8d62", ci=T)
rocobj2 <- lines.roc(df.1$type, df.1$freq, percent=T, col="#8da0cb", ci=T)
df.1 <- subset(df, processing == "conventional")
rocobj3 <- lines.roc(df.1$type, df.1$qual, percent=T, col="#66c2a5", ci=T)

sens.ci <- ci.se(rocobj1, specificities=seq(0, 100, 2))
plot(sens.ci, type="shape", col = alpha("#fc8d62", 0.5))
sens.ci <- ci.se(rocobj2, specificities=seq(0, 100, 2))
plot(sens.ci, type="shape", col = alpha("#8da0cb", 0.5))
sens.ci <- ci.se(rocobj3, specificities=seq(0, 100, 2))
plot(sens.ci, type="shape", col = alpha("#66c2a5", 0.5))

legend("bottomright", legend=c("MAGERI:MBEM", "MAGERI:FREQ", "conventional"), 
       col=c("#fc8d62", "#8da0cb", "#66c2a5"), lwd=2)
dev.off()

## todo: output

rocobj1
rocobj2
rocobj3

#df.1 <- subset(df, processing == "mageri" & type == "somatic")

df.roc<-data.frame(threshold = rocobj1$thresholds, specificity = rocobj1$specificities, sensitivity = rocobj1$sensitivities)