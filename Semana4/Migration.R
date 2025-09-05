library(ggpubr)
#https://bookdown.org/amesoudi/ABMtutorial_bookdown/model7.html
Migration <- function (N, p_0, q_0, m, t_max) {
  
  # create output dataframe to hold t_max values of p and q
  output <- data.frame(p = rep(NA, t_max), q = rep(NA, t_max)) 
  
  # create first generation of group 1
  agent1 <- data.frame(trait = sample(c("A","B"), N, replace = TRUE, 
                                      prob = c(p_0,1-p_0)), 
                       group = 1)  
  
  # create first generation of group 2
  agent2 <- data.frame(trait = sample(c("A","B"), N, replace = TRUE, 
                                      prob = c(q_0,1-q_0)), 
                       group = 2)  
  
  # combine agent1 and agent2 into a single agent dataframe
  agent <- rbind(agent1,agent2)  
  
  # store first generation frequencies
  output$p[1] <- sum(agent$trait[agent$group == 1] == "A") / N
  output$q[1] <- sum(agent$trait[agent$group == 2] == "A") / N
  
  for (t in 2:t_max) {
    
    # migration
    
    # 2N probabilities, one for each agent, to compare against m
    probs <- runif(1:(2*N))  
    
    # with prob m, add an agent's trait to list of migrants
    migrants <- agent$trait[probs < m]  
    
    # put migrants randomly into empty slots
    agent$trait[probs < m] <- sample(migrants, length(migrants))  
    
    # store frequencies in output slot t
    output$p[t] <- sum(agent$trait[agent$group == 1] == "A") / N
    output$q[t] <- sum(agent$trait[agent$group == 2] == "A") / N
    
  }
  
  plot(x = 1:nrow(output), y = output$p, 
       type = 'l', 
       col = "orange", 
       ylab = "proportion of agents with trait A", 
       xlab = "generation", 
       ylim = c(0,1), 
       main = paste("N = ", N, ", m = ", m, sep = ""))
  
  lines(x = 1:nrow(output), y = output$q, col = "royalblue")
  
  legend("topright", 
         legend = c("p (group 1)", "q (group 2)"), 
         lty = 1, 
         col = c("orange", "royalblue"), 
         bty = "n")
  
  output  # export data from function
}


data_model7 <- Migration(N = 10, # population size
                         p_0 = 1, #initial p
                         q_0 = 0, #initial q
                         m = 0.1, #strong migration
                         t_max = 100) #100 generations

##https://michitobler.github.io/primer-of-evolution/evolutionary-mechanisms-ii-mutation-genetic-drift-migration-and-non-random-mating.html
migration_rates <- c(0.010,0.025,0.100,0.500,1)
pm0 = 0.05
pi0 = 0.95

results <- data.frame(m=rep(migration_rates,each=100), generation=rep(1:100,times=length(migration_rates)), p=NA)
for(m in migration_rates) {
  pm <- pm0
  pi <- pi0
  results$p[results$m==m] <- pi
  for( t in 2:100){
    p.0 <- results$p[results$m==m & results$generation == (t-1)]
    p.1 <- (1-m)*p.0 + pm*m
    results$p[results$m==m & results$generation== t] <- p.1
  }
}
results$m <- factor(results$m)


ggpubr::ggline(results,x = "generation",y="p",color  = "m",
                xlab="Time (in generations)",ylab="Allele frequency")
