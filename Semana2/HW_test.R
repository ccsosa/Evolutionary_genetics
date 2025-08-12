library(ggplot2)
library(tibble)
library(tidyr)
# generate a range for p
p <- seq(0, 1, 0.01)
# and also for q
q <- 1 - p

# generate the expected genotype frequencies
A1A1_e <- p^2
A1A2_e <- 2 * (p * q)
A2A2_e <- q^2

# arrange allele frequencies into a tibble/data.frame
geno_freq <- as.tibble(cbind(p, q, A1A1_e, A1A2_e, A2A2_e))

# Use gather to reshape the data.frame for straightforward plotting
geno_freq <- gather(geno_freq, key = "genotype", value = "freq", -p, -q)

# plot the expected genotype frequencies
a <- ggplot(geno_freq, aes(p, freq, colour = genotype)) + geom_line()
a <-a + ylab("Genotype frequency") + xlab("p frequency")
a + theme_light() + theme(legend.position = "bottom")


################################################################################
HW_simulate <- function(pops,n,seed,x_size){
  set.seed(seed)
  # generate a range for p
  pops <- runif(n,min = 1,max = pops)
  pops <- round(pops,0)
  pops <- as.factor(as.character(pops))
  p <- runif(n, min = 0, max = 1)
  # and also for q
  q <- 1 - p
  
  # generate the expected genotype frequencies
  A1A1_e <- p^2
  A1A2_e <- 2 * (p * q)
  A2A2_e <- q^2
  
  # arrange allele frequencies into a tibble/data.frame
  geno_freq <- as.tibble(cbind(p, q, A1A1_e, A1A2_e, A2A2_e,pops))
  
  # Use gather to reshape the data.frame for straightforward plotting
  geno_freq <- gather(geno_freq, key = "genotype", value = "freq", -p, -q,-pops)
  geno_freq$pops <- factor(as.character(geno_freq$pops))
  geno_freq$genotype <- factor(as.character(geno_freq$genotype))
  
  print(table(geno_freq$pops)/3)
  geno_freq$p <- round(as.numeric(geno_freq$p),2)
  geno_freq$q <- round(as.numeric(geno_freq$q),2)
  geno_freq$freq <- round(as.numeric(geno_freq$freq),2)
  
  breaks <- unique(c(min(geno_freq$p),
                     sample(geno_freq$p,60),
                     max(geno_freq$p)))

  # plot the expected genotype frequencies
  a <- ggpubr::ggline(data = geno_freq, x = "p",
                      y = "freq",
                      color = "genotype",,
                      # x.text.angle = 90,
                      facet.by = "pops")+
    # scale_x_discrete(drop = T,) +   # keep all factor levels
     scale_x_discrete(breaks=breaks)+                                                      
    theme(axis.text.x = element_text(size = 8, 
                                       angle = 90, 
                                       hjust = 1))
  
  a
  # +
  #   a <-a + ylab("Genotype frequency") + xlab("p frequency")
  # a + theme_light() + theme(legend.position = "bottom")
  # a + facet_grid(pops, scales = "free")
}
HW_simulate(pops = 2,n = 100,seed = 1000,x_size=3)
HW_simulate(pops = 4,n = 200,seed = 1000,x_size=1)
