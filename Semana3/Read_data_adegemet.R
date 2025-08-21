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
library(DECIPHER)
library(vcfR)
library(seqinr)
library(iMKT)

# devtools::install_github("pievos101/PopGenome")
# library(PopGenome)

#read_snps
# data <- vcfR::read.vcfR("D:/DESCARGAS/VCF/Corredor_et_al.vcf")
# gi <- vcfR2genind(data, sep = "/", ploidy = 2, NA.char = ".", type = "codom")


#read sequences
data_r <- Biostrings::readDNAStringSet("D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/test_clase.fasta")
# perform the alignment
aligned <- DECIPHER::AlignSeqs(data_r)
# BrowseSeqs(aligned, highlight=0)
Biostrings::writeXStringSet(aligned,
                file="D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/aligned_test.fas",format = "fasta")
data_r <- seqinr::read.alignment("D:/PROGRAMAS/Dropbox/uniquindio_gen_ii/MATERIAL/PRACTICA2/aligned_test.fas",format = "fasta")
obj <- adegenet::alignment2genind(data_r, polyThres=0.01)
tabAA <- adegenet::genind2df(obj)
table(unlist(tabAA))
D <- dist(tab(obj))
# Convertir a tabla binaria
X <- tab(obj, NA.method="mean")  # imputar NAs con la media


# Clustering jerárquico (UPGMA)
hc <- hclust(D, method="average")
hc$labels <- 1:200
plot(hc, cex=0.7, main="UPGMA clustering - ITS2 OTUs")
# cortar dendrograma en 5 grupos (ejemplo)
clusters <- cutree(hc, k=5)
clusters <- as.factor(clusters)
# PCA Adegenet
pca1 <- dudi.pca(X, scale=FALSE, scannf=FALSE, nf=3)
barplot(pca1$eig[1:50], main = "PCA eigenvalues", col = heat.colors(50))
col <- funky(5)

s.class(pca1$li, clusters,xax=1,yax=3, col=transp(col,.6), 
        axesell=FALSE,
cstar=0, cpoint=3, grid=FALSE)
add.scatter.eig(pca1$eig[1:20], 3,1,2)
