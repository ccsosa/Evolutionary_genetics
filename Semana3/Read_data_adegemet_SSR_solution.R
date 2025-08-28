library(adegenet)
library(hierfstat)
library(poppr)
# Cargar tabla
tab <- read.csv("D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/DataMEC-11-0816.R1.txt",
                sep="\t", row.names = 1)

# Reemplazar guiones y puntos por guiones bajos
colnames(tab) <- gsub("[.-]", "_", colnames(tab))

# Ahora volver a definir mic
mic <- colnames(tab[,-c(1,2)])

# Crear objeto genind
tabAA <- adegenet::df2genind(tab[, mic],
                             sep = "/",
                             # ncode = 2,
                             ind.names = row.names(tab),
                             loc.names = mic,
                             pop = factor(tab$Region),
                             NA.char = "0"
)
X <- adegenet::tab(tabAA, NA.method="mean")  # imputar NAs con la media
# 
# pca1 <- dudi.pca(X, scale=FALSE, scannf=FALSE, nf=3)
# barplot(pca1$eig[1:50], main = "PCA eigenvalues", col = heat.colors(50))
# 
# col <- funky(5)
# # scatter(pca1)
# 
# s.class(pca1$li,as.factor(tab$Region),xax=1,yax=3, col=transp(col,.6), 
#         axesell=FALSE,
#         cstar=1, cpoint=0.5, grid=FALSE)
# add.scatter.eig(pca1$eig[1:20], 3,1,2)
# 
# #SUMMARIES
# summary(tabAA)
# poppr(tabAA)
# #He
# adegenet::Hs(tabAA)
# #Ploidy
# adegenet::ploidy(tabAA)
# #HW
# pegas::hw.test(tabAA)
# #to pegas object
# pegAA <- pegas::genind2loci(tabAA)
# #Fst
# pegas::Fst(pegAA)
# pegas::haploNet(pegAA)
# pegas::H(pegAA)