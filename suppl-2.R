library(ggplot2); library(reshape); library(binom); library(plyr)

df <- read.table("summary.txt", header=T, sep = "\t")
df$freq <- as.numeric(as.character(df$freq))
df.s <- subset(df, processing == "mageri" & type == "somatic")
df.s$name <- gsub("CONTROL_", "", df.s$name)
df.s$name <- gsub("_", ":", df.s$name)
df <- subset(df, processing == "mageri" & type == "error")

# todo: mig size distribution plot

### Figure S2

pdf("figures/fig.s1a.pdf")
ggplot(df, aes(x=cqs)) + geom_histogram(binwidth=1, fill = "#2b8cbe") +
  scale_x_continuous(limits=c(2,40),expand=c(0,0)) + xlab("Consensus quality score") +
  scale_y_continuous(limits=c(0,1000),expand=c(0,0)) + ylab("") +
  scale_fill_brewer(palette="Set1") +  
  theme_bw()
dev.off()

df.1 <- data.frame(x=df$freq * 100000)
df.1$variable <- rep("observed", nrow(df.1))
df.2 <- data.frame(x=rpois(100000, 1e-5*100000))
df.2$variable <- rep("expected", nrow(df.2))
df.1 <- rbind(df.1, df.2)

pdf("figures/fig.s1b.pdf")
ggplot(df.1, aes(x=x,fill=variable)) + 
  geom_histogram(aes(y = ..density..)) +   
  scale_x_log10(limits=c(1,1000), expand=c(0,0)) + 
  scale_y_continuous(expand=c(0,0), limits = c(0,10)) +
  ylab("") +
  xlab("Variant size, MIGs") +
  scale_fill_brewer(palette="Set1") +  
  theme_bw()
dev.off()

### Figure S3
df$subst <- paste(df$from, df$to, sep =">")

df.3 <- ddply(df, .(from, to, subst), summarize, 
              sum = sum(freq * depth),
              unique = sum(freq > 0))

percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

pdf("figures/fig.s1c.pdf", useDingbats=F)
ggplot(df.3) + 
  geom_point(aes(x=1, y=1, size=sum/sum(sum), fill = subst),colour="black", pch=21) + 
  geom_text(aes(label = percent(sum/sum(sum)), x=1, y=1), vjust=-3) + 
  facet_grid(from~to) + scale_fill_brewer(guide=F,palette="Paired") +
  scale_size_area(guide=F, limits=c(0,0.5), max_size=30)+
  scale_x_continuous("",expand=c(0,0)) +
  scale_y_continuous("",expand=c(0,0)) +
  theme_bw() +
  theme(axis.text.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.x=element_blank(), axis.ticks.y=element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

pdf("figures/fig.s1e.pdf")
ggplot(df, aes(x=errrate.est, y=freq)) + geom_abline(intercept = 0, slope = 1,linetype="dashed") +
  stat_density2d(aes(alpha=..level.., fill=..level..), size=3, bins=10, geom="polygon") + 
  scale_fill_gradient(low="gray25", high="red") +
  scale_alpha(range = c(0.1, 0.5), guide = FALSE) +
  geom_density2d(colour="black", alpha=0.5, bins=10, size = 0.1) +
  scale_x_log10(limits=c(1e-5,1e-2)) + scale_y_log10(limits=c(1e-5,1e-2)) + 
  facet_grid(from~to) + theme_bw()
dev.off()

lm_eqn <- function(m){
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(coef(m)[1], digits = 2), 
                        b = format(coef(m)[2], digits = 2), 
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq))
}

df.s1 <- ddply(df.s, .(name), summarize, 
              observed = mean(freq),
              expected = mean(known.freq),
              quality = mean(qual))

pdf("figures/fig.s3a.pdf", useDingbats=F)
ggplot(df.s1, aes(x=expected, y=observed)) + 
  geom_smooth(color="black",method="lm", fullrange=T, linetype="dashed") +
  geom_point(aes(color=quality, size=log10(quality)),alpha=0.6) +
  geom_text(aes(label=name, size=log10(quality))) +
  scale_colour_gradient(low="orange", high="red",limits=c(20,1000))+
  scale_size_continuous(guide=F)+
  geom_text(data = data.frame(), aes(x=1e-3, y=5e-2), label = lm_eqn(lm(observed ~ expected, df.s1)), parse = TRUE) +
  scale_x_log10(limits=c(1e-4,1e-1)) + scale_y_log10(limits=c(1e-4,1e-1)) + 
  theme_bw() 
dev.off()

df.s$replica <- paste("sample", df.s$replica, sep="")
df.s2 <- cast(df.s, name~replica, value="freq")

pdf("figures/fig.s3b.pdf", useDingbats=F)
ggplot(df.s2, aes(x=sample1, y=sample2)) + 
  geom_smooth(color="black",method="lm", fullrange=T, linetype="dashed") +
  geom_point(size=10,color="orange",alpha=0.6) +
  geom_text(aes(label=name)) +
  geom_text(data = data.frame(), aes(x=1e-3, y=5e-2), label = lm_eqn(lm(sample1 ~ sample2, df.s2)), parse = TRUE) +
  scale_x_log10(limits=c(1e-4,1e-1)) + scale_y_log10(limits=c(1e-4,1e-1)) + 
  theme_bw() 
dev.off()

# Supplementary figure 8

df <- read.table("hiv/hiv.SRR1763769.variant.caller.txt", header=T)
df <- subset(df, coverage > 10000 & count.major / coverage < 0.01)

coverage <- mean(df$coverage)

er <- 0.0001
er.min <- max(1e-5, er - 1.96 * sqrt(er * (1-er) / coverage))
er.max <- er + 1.96 * sqrt(er * (1-er) / coverage)

pdf("figures/fig.s8a.pdf")
ggplot(df, aes(x=error.rate)) +
  geom_rect(aes(xmin=er.min, xmax=er.max, ymin = 0, ymax = 50), fill="gray90") +
  geom_vline(xintercept = 0.0001, linetype="dashed") +
  geom_histogram() +
  scale_x_log10(limits=c(1e-5, 1e-2), expand=c(0,0)) + scale_y_continuous(expand=c(0,0))+
  xlab("Error rate") + ylab("") + theme_bw()
dev.off()


df.s <- ddply(df, .(count.major), summarize, freq = length(count.major))
#df.s <- rbind(df.s, c(0, NA))
df.s$estimate <- 297 * dpois(df.s$count.major, 0.0001 * coverage)

pdf("figures/fig.s8b.pdf")
ggplot(df.s, aes(x=count.major)) + 
  geom_ribbon(aes(ymax=estimate, ymin=0), alpha = 0.3, fill="blue") + 
  geom_line(aes(y=freq), linetype="dashed") + 
  geom_point(aes(y=freq)) + geom_text(aes(y=freq + 3, label = freq), color="red") + 
  xlab(paste("UMI tag count for erroneous variant")) + ylab("Number of variants") +
  theme_bw()
dev.off()
