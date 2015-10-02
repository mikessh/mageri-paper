library(pROC); library(scales); library(iNEXT); library(plyr); library(scales)

df <- read.table("summary.txt", header=T, sep ="\t")
df$qual <- as.numeric(as.character(df$qual))
df$freq<- as.numeric(as.character(df$freq))

### Figure 2

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

# todo: to file
rocobj1
rocobj2
rocobj3

#
df.v <- read.table("h4_hd734_variants.vcf", header = T, comment="##", sep = "\t")
df <- read.table("capture.txt", header = T, sep = "\t")
# rare variants
df.v <- subset(df.v, INFO < 0.005)
df <- subset(df, known.freq < 0.005)
total <- nrow(df.v) * length(unique(df$replica))

df$exp.freq <- 1-dbinom(0, df$depth, df$freq)

df.1 <- ddply(df, .(size), summarize, 
              obs.rate = length(freq > 0) / total,
              obs.ci = 1.96 * sqrt(length(freq > 0) / total * (1 - length(freq > 0) / total) / total),
              exp.rate = mean(exp.freq),
              exp.ci = 1.96 *
                sqrt(sd(exp.freq)^2*((length(exp.freq)-1)/length(exp.freq))) / # recalc to pop sd
                sqrt(length(exp.freq)
              )

df.2 <- data.frame(size=c(as.character(df.1$size), as.character(df.1$size)),
                   type=c(rep("MAGERI",nrow(df.1)), rep("theoretical",nrow(df.1))),
                   value=c(df.1$obs.rate, df.1$exp.rate),
                   ci=c(df.1$obs.ci, df.1$exp.ci))

#df$dummy <- NA
df.2$size <- factor(df.2$size, levels = c("0.1mln", "1mln", "10mln", "full"))

col <- c("#ff7f00", "#1f78b4")

pdf("out/fig2a.pdf")
ggplot(df.2, aes(x=as.numeric(size), fill=type)) +
  
  geom_ribbon(aes(ymin=value-ci, ymax=value+ci), alpha=0.2) +  
  
  geom_line(aes(y=value, color=type), size = 1, alpha=0.9) +
  
  geom_point(aes(y=value, color=type), size=6.5, shape=21) +
  
  #  geom_point(aes(y=value, color=dummy, fill=dummy), size=5, shape=21)  +  
  
  geom_hline(y=0.348, linetype="dashed") +
  
  annotate("text", label = "raw data, conventional processing", x=2.5, y=0.37) +
  
  scale_color_manual("", values=col, na.value="white") +  
  scale_fill_manual("", values=col, na.value="white") +
  
  scale_x_continuous(breaks=1:4, labels=levels(df$size)) + 
  scale_y_continuous(limits=c(0,1), expand=c(0,0), labels = percent_format(), oob=scales::rescale_none) +
  ylab("Rare variants recovered") +
  xlab("Sample size, reads") +
  theme_bw()
dev.off()