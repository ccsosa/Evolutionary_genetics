require(car)

# Frecuencias del alelo A
p <- seq(0, 1, 0.1)
q <- 1 - p

# Data frame con frecuencias bajo Hardy-Weinberg
x <- data.frame(
  AA = p^2,          # Homocigoto dominante
  Aa = 2 * p * q,    # Heterocigoto
  aa = q^2           # Homocigoto recesivo
)

# Calcular Ho y He
x$Ho <- x$Aa               # Observada (igual a esperada en este caso)
x$He <- 1-((x$AA^2)+(x$aa^2))

# Graficar Ho
scatter3d(
  x = x$AA, 
  y = x$aa, 
  z = x$Ho,
  xlab = "AA",
  ylab = "aa",
  zlab = "Ho",
  point.col = "blue",
  point.size = 8,
  surface = FALSE
)

# Graficar He
scatter3d(
  x = x$AA, 
  y = x$aa, 
  z = x$He,
  xlab = "AA",
  ylab = "aa",
  zlab = "He",
  point.col = "red",
  point.size = 8,
  surface = FALSE
)
