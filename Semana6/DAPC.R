# # DAPC requires the adegenet package. Let's load this package:
# library("adegenet")
# data(H3N2) # load the H3N2 influenza data. Type ?H3N2 for more info.
# pop(H3N2) <- H3N2$other$epid
# dapc.H3N2 <- dapc(H3N2, var.contrib = TRUE, scale = FALSE, n.pca = 30, n.da = nPop(H3N2) - 1)
# scatter(dapc.H3N2, cell = 0, pch = 18:23, cstar = 0, mstree = TRUE, lwd = 2, lty = 2)
# 
# set.seed(4)
# contrib <- loadingplot(dapc.H3N2$var.contr, axis = 2, thres = 0.07, lab.jitter = 1)
# 
# temp    <- seploc(H3N2)       # seploc {adegenet} creates a list of individual loci.
# 
# x <- adegenet::dist.genpop(H3N2,method = 1)
# 

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


#calculate populations distances
XX <- genind2genpop(tabAA)
xx <- dist.genpop(XX)

plot(hclust(xx))

# pca1 <- dudi.pca(X, scale=FALSE, scannf=FALSE, nf=3)
# barplot(pca1$eig[1:50], main = "PCA eigenvalues", col = heat.colors(50))
#CREATING CROSSVALIDATIO
set.seed(999)

system.time(pramx <- xvalDapc(X,pop(tabAA),
                              n.pca = 10:20, n.rep = 100,
                              parallel = "multicore", ncpus = 4L))


scatter(pramx$DAPC, cex = 0.2, legend = TRUE,
        clabel = FALSE, posi.leg = "bottomleft", scree.pca = TRUE,
        posi.pca = "topleft", cleg = 0.75, xax = 1, yax = 2, inset.solid = 1)

compoplot(pramx$DAPC)


assignplot(pramx$DAPC)
# 
# col <- funky(5)
# # scatter(pca1)
# 
# s.class(pca1$li,as.factor(tab$Region),xax=1,yax=3, col=transp(col,.6), 
#         axesell=FALSE,
#         cstar=1, cpoint=0.5, grid=FALSE)
# add.scatter.eig(pca1$eig[1:20], 3,1,2)
