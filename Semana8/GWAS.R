#library(rrBLUP)
#library(BGLR)
#library(DT)
###library(SNPRelate)
#library(dplyr)
#library(qqman)
#library(poolR)

# 
# if (!requireNamespace("BiocManager", quietly=TRUE))
#   install.packages("BiocManager")
# BiocManager::install("SNPRelate",force = T)
# BiocManager::install("CNEr",force = T)
# BiocManager::install("biomaRt",force = T)
 # BiocManager::install('grimbough/biomaRt', ref = "v2.60.1")

pacman::p_load(rrBLUP, BGLR, DT, dplyr, qqman,poolr,SNPRelate,biomaRt,gprofiler2)
#https://whussain2.github.io/Materials/Teaching/GWAS_R_2.html#content
#formats: https://www.cog-genomics.org/plink/1.9/formats#fam

rm(list = ls())
setwd("D:/GWAS_TEST/RiceDiversity_44K_Genotypes_PLINK")
Geno <- read_ped("sativas413.ped")
p = Geno$p
n = Geno$n
Geno = Geno$x
# Acession information
FAM <- read.table("sativas413.fam")
# Map information
MAP <- read.table("sativas413.map")
# Recode the data in ped file
Geno[Geno == 2] <- NA  # Converting missing data to NA
Geno[Geno == 0] <- 0  # Converting 0 data to 0
Geno[Geno == 1] <- 1  # Converting 1 to 1
Geno[Geno == 3] <- 2  # Converting 3 to 2
# Convert the marker data into matrix and transponse and check dimensions
Geno <- matrix(Geno, nrow = p, ncol = n, byrow = TRUE)
Geno <- t(Geno)
dim(Geno)



################################################################################
rice.pheno <- read.table("http://www.ricediversity.org/data/sets/44kgwas/RiceDiversity_44K_Phenotypes_34traits_PLINK.txt", 
                         header = TRUE, stringsAsFactors = FALSE, sep = "\t")
# See first few columns and rows of the data
rice.pheno[1:5, 1:5]
dim(rice.pheno)

# datatable(rice.pheno, rownames = FALSE, filter='top', options =
# list(pageLength = 3, scrollX=T)) assign the row names to marker file and
# compare it with phenotypic file
rownames(Geno) <- FAM$V2
table(rownames(Geno) == rice.pheno$NSFTVID)

# Now let us extract the first trait and assign it to object y
y <- matrix(rice.pheno$Flowering.time.at.Arkansas)  # # use the first trait 
rownames(y) <- rice.pheno$NSFTVID
index <- !is.na(y)
y <- y[index, 1, drop = FALSE]  # 374
Geno <- Geno[index, ]  # 374 x 36901
table(rownames(Geno) == rownames(y))

################################################################################
###QUALITY CONTROL
for (j in 1:ncol(Geno)) {
  Geno[, j] <- ifelse(is.na(Geno[, j]), mean(Geno[, j], na.rm = TRUE), Geno[, 
                                                                            j])
}

# Filter for minor alleles
p <- colSums(Geno)/(2 * nrow(Geno))
maf <- ifelse(p > 0.5, 1 - p, p)
maf.index <- which(maf < 0.05)
Geno1 <- Geno[, -maf.index]
dim(Geno1)


# Check the number of markers dropped Match with the map info file and save
# it as MAP1
setwd("D:/GWAS_TEST/RiceDiversity_44K_Genotypes_PLINK")
MAP <- read.table("sativas413.map")
dim(MAP)

MAP1 <- MAP[-maf.index, ]
dim(MAP1)


# Create geno matrix file and assign the row and column names from fam and
#map files
#FAM2 <- FAM[index, ]
#Geno <- Geno

Geno1 <- as.matrix(Geno1)
#rownames(Geno1) <- FAM2$V2
sample <- row.names(Geno1)
length(sample)


colnames(Geno1) <- MAP1$V2
snp.id <- colnames(Geno1)
length(snp.id)



# create gds formate file with marker and sample ids and save it as 44k.gds
snpgdsCreateGeno("44k.gds", genmat = Geno1, sample.id = sample, snp.id = snp.id, 
                 snp.chromosome = MAP1$V1, snp.position = MAP1$V4, snpfirstdim = FALSE)
# Now open the 44k.gds file
geno_44k <- snpgdsOpen("44k.gds")
snpgdsSummary("44k.gds")



# Now perform the pca analysis and plot it
pca <- snpgdsPCA(geno_44k, snp.id = colnames(Geno1))


pca <- data.frame(sample.id = row.names(Geno1), EV1 = pca$eigenvect[, 1], EV2 = pca$eigenvect[, 
  2], EV3 = pca$eigenvect[, 3], EV3 = pca$eigenvect[, 4], stringsAsFactors = FALSE)
# Plot the PCA
plot(pca$EV2, pca$EV1, xlab = "eigenvector 3", ylab = "eigenvector 4")




# Now let us add the population information to the plot. Here we will be
# using the population information from the PCA file available online
pca_1 <- read.csv("http://ricediversity.org/data/sets/44kgwas/RiceDiversity.44K.germplasm.csv", 
                  header = TRUE, skip = 1, stringsAsFactors = FALSE)  # 431 x 12
pca_2 <- pca_1[match(pca$sample.id, pca_1$NSFTV.ID), ]
table(pca_1$sample.id == pca_2$NSFTV.ID)



# Extract the population information and add the pca output file
pca_population <- cbind(pca_2$Sub.population, pca)
colnames(pca_population)[1] <- "population"
# Plot and add the population names
plot(pca_population$EV1, pca_population$EV2, xlab = "PC1", ylab = "PC2", col = c(1:6)[factor(pca_population$population)])
legend(x = "topright", legend = levels(factor(pca_population$population)), col = c(1:6), 
       pch = 1, cex = 0.6)



################################################################################
# create the geno file for rrBLUP package GWAS analysis
geno_final <- data.frame(marker = MAP1[, 2], chrom = MAP1[, 1], pos = MAP1[, 
               4], t(Geno1 - 1), check.names = FALSE)  # W = \in{-1, 0, 1}
dim(Geno1)



# create the pheno file
pheno_final <- data.frame(NSFTV_ID = rownames(y), y = y)
# Run the GWAS analysis
GWAS <- GWAS(pheno_final, geno_final, min.MAF = 0.05, P3D = TRUE, plot = FALSE)


#get chromosomes
chrs <- list()
for(i in 1:12){
  chrs[[i]] <- MAP1$V2[MAP1$V1==i]  
};rm(i)



# Read the genotypic file and create a matrix for each chromosome
corr.matrix1 <- cor(Geno1[, chrs[[1]]])
corr.matrix2 <- cor(Geno1[,  chrs[[2]]])
corr.matrix3 <- cor(Geno1[,  chrs[[3]]])
corr.matrix4 <- cor(Geno1[,  chrs[[4]]])
corr.matrix5 <- cor(Geno1[,  chrs[[5]]])
corr.matrix6 <- cor(Geno1[,  chrs[[6]]])
corr.matrix7 <- cor(Geno1[,  chrs[[7]]])
corr.matrix8 <- cor(Geno1[,  chrs[[8]]])
corr.matrix9 <- cor(Geno1[,  chrs[[9]]])
corr.matrix10 <- cor(Geno1[,  chrs[[10]]])
corr.matrix11 <- cor(Geno1[,  chrs[[11]]])
corr.matrix12 <- cor(Geno1[,  chrs[[12]]])
# Now use the meff function from pacakge to get effective number of tests
# for each chromosome
meff_liji_1 <- meff(corr.matrix1, method = "liji")
meff_liji_2 <- meff(corr.matrix2, method = "liji")
meff_liji_3 <- meff(corr.matrix3, method = "liji")
meff_liji_4 <- meff(corr.matrix4, method = "liji")
meff_liji_5 <- meff(corr.matrix5, method = "liji")
meff_liji_6 <- meff(corr.matrix6, method = "liji")
meff_liji_7 <- meff(corr.matrix7, method = "liji")
meff_liji_8 <- meff(corr.matrix8, method = "liji")
meff_liji_9 <- meff(corr.matrix9, method = "liji")
meff_liji_10 <- meff(corr.matrix10, method = "liji")
meff_liji_11 <- meff(corr.matrix11, method = "liji")
meff_liji_12 <- meff(corr.matrix12, method = "liji")

# Now sum up all the effective tests to get effective number of independent
# tests
Meff <- sum(meff_liji_1, meff_liji_2, meff_liji_3, meff_liji_4, meff_liji_5, 
            meff_liji_6, meff_liji_7, meff_liji_8, meff_liji_9, meff_liji_10, meff_liji_11, 
            meff_liji_12)


p_threshold = (1 - (1 - 0.05))^1/Meff
p_threshold



################################################################################
#filter GWAS markers
GWAS_1 <- GWAS %>% filter(y != "0")
# List of significant SNPs
GWAS_1 %>% filter(y < 1e-04)

################################################################################
manhattan(x = GWAS_1, chr = "chrom", bp = "pos", p = "y", snp = "marker", col = c("blue4", 
                                                                                  "orange3"), suggestiveline = -log10(1e-04), logp = TRUE)

################################################################################
#filtered markers
GWAS_filtered <- GWAS_1[GWAS_1$y<1e-04,]

################################################################################
#get gene name
# Connect to Plants Ensembl

osativa <- useEnsemblGenomes(biomart = "plants_mart", 
                                         dataset = "osativa_eg_gene")

# plants_mart <- useEnsembl(biomart = "plants_mart",
#                           # dataset = "osativa_eg_gene",
#                           host = "plants.ensembl.org")
# 
# # Select a specific plant dataset
# osativa <- useDataset(dataset = "osativa_eg_gene", 
#                         mart = plants_mart)
# attributes <- listAttributes(osativa)


all.genes <- list()
for(i in 1:nrow(GWAS_filtered)){
  all.genes[[i]] <- getBM(
    attributes=c("ensembl_gene_id","chromosome_name","start_position","end_position","description","external_gene_name"),
    filters=c("chromosome_name", "start", "end"),
    values=list(chromosome=GWAS_filtered$chrom[[i]], 
                start=GWAS_filtered$pos[[i]]-5000,
                end=GWAS_filtered$pos[[i]]+5000),
    mart=osativa)
  
}

all.genes <- do.call(rbind,all.genes)

################################################################################
#Functional Enrichment Analysis
x_s <-  gprofiler2::gost(query = unique(all.genes$ensembl_gene_id),
                         organism = "osativa", ordered_query = FALSE,
                         multi_query = FALSE, significant = TRUE, exclude_iea = FALSE,
                         measure_underrepresentation = FALSE, evcodes = FALSE,
                         user_threshold = 0.05, correction_method = "g_SCS",
                         domain_scope = "annotated", custom_bg = NULL,
                         numeric_ns = "", sources = "GO:MF", as_short_link = FALSE)
x_s$result
