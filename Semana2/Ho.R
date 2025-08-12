require(car)

x <- data.frame(
  AA = seq(0, 1, 0.1),      # Frecuencia de AA desde 0 a 1
  aa = 1 - seq(0, 1, 0.1),  # Frecuencia de aa complementaria
  p2 = NA,
  q2 = NA,
  pq_2 = NA,
  He = NA,                  # Columna vacía para heterocigosidad esperada
  Ho = NA                   #Columna vacía para heterocigosidad observada
  )          

x$p2 <- x$AA^2
x$q2 <- x$a^2
x$pq_2 <- 2*(x$AA*x$aa)
x$He <- 1 - ((x$AA^2) + (x$aa^2))
#x$Ho <- 1 - (x$AA + x$aa)

scatter3d(
  x = x$p2, 
  y = x$q2, 
  z = x$pq_2, 
  xlab = "AA", 
  ylab = "aa", 
  zlab = "He",
  point.col = "red",
  point.size = 8,
  surface = FALSE
)
