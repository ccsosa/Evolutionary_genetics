# library(ape)
# ref <- c("U15717", "U15718", "U15719", "U15720",
#          "U15721", "U15722", "U15723", "U15724")
# myDNA <- read.GenBank(ref)
# myDNA
# library(vcfR)
# install.packages("vcfR")
# devtools::install_github("sergihervas/iMKT")

#https://datadryad.org/dataset/doi:10.5061/dryad.tx95x6b26
library(pegas)
library(adegenet)
# library(DECIPHER)
library(vcfR)
# library(seqinr)
# library(iMKT)

# devtools::install_github("pievos101/PopGenome")

#read_snps
data <- vcfR::read.vcfR("D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/VCF/Corredor_et_al.vcf")
gi <- vcfR::vcfR2genind(data, sep = "/", ploidy = 2, NA.char = ".", type = "codom")
pop <- read.table("D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/VCF/pop.txt",header = F)
pop(gi) <- factor(pop$V1)
pop_clusters <- factor(pop$V1)

X <- tab(gi, NA.method="mean")  # imputar NAs con la media

pca1 <- dudi.pca(X, scale=FALSE, scannf=FALSE, nf=3)
barplot(pca1$eig[1:50], main = "PCA eigenvalues", col = heat.colors(50))

 col <- funky(5)
# scatter(pca1)

s.class(pca1$li,as.factor(pop_clusters),xax=1,yax=3, col=transp(col,.6), 
        axesell=FALSE,
        cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca1$eig[1:20], 3,1,2)

