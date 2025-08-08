props <- c(189, 89, 9)
total <- sum(props)

pA <- (2 * props[1] + props[2]) / (2 * total)
pa <- 1 - pA

expected <- c(
  pA^2 * total,
  2 * pA * pa * total,
  pa^2 * total
)

chisq <- sum((props - expected)^2 / expected)
p.value <- pchisq(chisq, df = 1, lower.tail = FALSE)

chisq
p.value
