require(DECIPHER)
require(ape)
require(Biostrings)
require(phangorn)
require(gprofiler2)
require(rentrez)
require(biomaRt)
options(biomaRt.cache = T)

seq_dir <- ("D:/REPO_GITHUB/EVOL_GENETICS/Semana7")
if(!dir.exists(paste0(seq_dir,"/","seqs"))){
  dir.create(paste0(seq_dir,"/","seqs"))
}

seqs_dir_fas <- paste0(seq_dir,"/","seqs")
# targets <- c("athaliana","tcacao",
#              "zmays", #"ccanephora",
#              "sbicolor","scereale",
#              "sitalica", "taestivum",
#              "hvulgare","oglaberrima", 
#              # "macuminata",
#              # "oglumipatula",
#              "hannuus")
# x_list <- list()
# genomic_seqs <- list()
# # i <- 1
# 
# query = "Os03g0133500"
# 
# 
# 
# os <- ">Os03g0133500 class=Sequence_position=chr03:1882042..1884078 (-strand)
# GGATTGCATTAGTTGCAATTGGTTCTTCTTCAGAGAGGCTAATTAGTGTGACAAATCGATCCCGATTGCTGGTACACGAGCTGCCATGGAAGGCTGTATGCCGAGCGATGCAAACTACGCGCCGCTCACCCCGGTGAGCTTCTTGGAGCGCGCCGCCGTCGTGTACGGTGACCGCACGGCCGTCGTCTCTGGCGGCAGGGAGTACTCGTGGCGCGAGACGCGGGAACGGTGCCTCGCTGGGGCGTCCGCGCTCGCGCGCCTCGGCGTCGGCCGCCGGGACGTGGTAAGTGATCGACCAGAGCTTGATGCCTCGATGAGCTTTGTACTTGGTGCCAATTCAGCTCTCAACAAGACATGGGTTAATTGCTGGTCAGGTCGCCGTCATCGCAGCGAACATTCCGGCGATGTACGAGCTGCACTTCAGCGTGCCGATGGCCGGCGGCGTGCTCTGCACGCTGAACACCCGGCACGACGCGGCCATGGTGTCCGTCCTTCTCAGACATTCGGAGGCCAAGGTTTTCCTCGTCGAATCGCAGTTCCTCGCCGTCGCCCACGACGCCCTGAGGCTGCTCGCCGATGCTAAAGCCAAATTTCCCCTTGTCATCGCGATCTCCGACACCGGCGACAGCAGCAGCAGCGACGGTGGCGGGCTAGAGTACGAGGCGCTTCTGAGGGACGCGCCGCGGGGCTTCGAGATCAGGTGGCCGGCCGACGAGCGCGACCCGATATCGCTCAACTACACGTCGGGGACGACGTCGAGGCCGAAGGGCGTCATCTACAGCCACCGCGGCGCGTACCTGAACTCGCTGGCCGCGCTGCTCTGCAACGACATGACGTCCATGCCGGTGTACCTCTGGACCGTGCCCATGTTCCACTGCAACGGGTGGTGCATGGCGTGGGCCACGGCGGCGCAGGGCGGGACGAACATCTGCGTCAGGAACGTCGTGCCCAAGGTCATCTTCGAGCAGATCGTGCGCCACGGCGTGACCAACATGGGCGGCGCGCCCACGGTGCTCAACATGATCGTGAACGCGCCGGCGTCGGAGCGGAGGCCGCTGCCGAGGAGGGTGCTCATCTCGACGGGCGGCGCGCCGCCGCCTCCGCAGGTGCTGGCCAAGATGGAGGAGCTCGGTTTCAACGTCCAGCACGGGTACGGCCTCACCGAGACGTACGGGCCGGCGACGCGGTGCGTGTGGAGACCCGAGTGGGACGCGCTGCCGCTCGCCGAGCGCGCGCGGATCAAGGCGCTCCAGGGGGTGCAGCACCAGATGTTGCAGGACGTCGACATCAAGGACCCGGTGACCATGGCGAGCGTGCCGTCCGACGGGCGCGCCGTCGGCGAGGTCATGCTCCGCGGCAACACGGTCATGAGCGGGTACTACAAGGACGCGGCGGCCACGGAGGAGGCCATGCGCGGCGGGTGGCTGCGCACGGGCGACCTCGGCGTGCGCCACCCTGACGGGTATATCCAGCTCAAGGATCGCGCCAAGGACATCATCATATCGGGCGGCGAGAACATCAGCTCGATCGAGGTGGAGTCGGTGCTGTTCGGCCACCACGCGGTGCTCGACGCGGCGGTGGTGGCGAGGCCGGACGACCACTGGGGCGAGACGGCGTGCGCGTTCGTCACGCTGAAGGACGGGGCAAGCGCGACGGCGCACGAGATCATCGCGTTCTGCCGTGCGCGGCTGCCGCGTTACATGGCGCCGAGGACGGTGGTGTTCGGCGACCTGCCCAAGACGTCGACGGGGAAGACGCAGAAGTTCTTGCTCCGGGAGAAGGCCAGGGCCATGGGAAGCCTGCCTATGCAAAGCAAATCCAAGTTGTAGTCTTGTACTATTGTACTAGCTGCGATTGGTTTTGCTGCCAAGATGACAGCGCCCTGCACGACTACTCCGATATTTTCTGATGATACAGTATTTGGGAAGACCAACACGGATGTTGCATAAATTCCGTGTTAAAACTGAGTCAAGTGCAGCATCATGTAGGATGCACTTAAAAGTAATCATAAAAAAGAATATACCCTCTTATTCGGGG"
# for(i in 1:length(targets)){
#   message(i)
#    # i <- 3
#   Sys.sleep(0.5)  # prevent race conditions
#   x_list[[i]] <- gprofiler2::gorth(query = query, 
#                                    source_organism = "osativa",
#                                    mthreshold = 1,
#                                    target_organism = targets[[i]])
# 
#   # x_mart <- useMart(biomart = "plants_mart", 
#   #                   dataset = paste0(targets[[i]],"_eg_gene"),
#                     # host = "https://plants.ensembl.org")
#   plants_mart <- biomaRt::useEnsemblGenomes(biomart = "plants_mart",
#                                    dataset = paste0(targets[[i]],"_eg_gene"))
# 
#   
#   attributes <- c("ensembl_gene_id", 
#                   "external_gene_name",
#                   "chromosome_name",
#                   "start_position",
#                   "end_position",
#                   "entrezgene_id",
#                   "entrezgene_description"
#                   )
#   
#   pos <- biomaRt::getBM(attributes = attributes, 
#                 filters = "ensembl_gene_id",
#                 values = x_list[[i]]$ortholog_ensg,
#                 mart = plants_mart)
#   
#   if(nrow(pos)>0){
#     if(is.na(pos$entrezgene_id)){
#       genomic_seqs[[i]] <- NULL
#     } else {
#       linked_seq_ids <- rentrez::entrez_link(dbfrom="gene", id=pos$entrezgene_id, db="nuccore",cmd = "neighbor_score")
#       # genomic_seqs[[i]] <-
#         Sys.sleep(0.5)  # prevent race conditions
# 
#       seq <-   rentrez::entrez_fetch(db="nuccore", id=linked_seq_ids$links$gene_nuccore_refseqrna[[1]], rettype="fasta")
#       write(seq, file=paste0(seqs_dir_fas,"/",targets[[i]],".fasta"))
#       
#     }
#   } else {
#     genomic_seqs[[i]] <- NULL
#   }
#   Sys.sleep(0.5)  # prevent race conditions
#   
# 
#   # biomaRt::getSequence(chromosome = pos$chromosome_name,
#   #                      start = pos$start_position,
#   #                      end = pos$end_position,
#   #                      seqType="gene_exon_intron",
#   #                      id = pos$ensembl_gene_id,
#   #                      mart = x_mart)
# }
# 
# genomic_seqs <- genomic_seqs[!sapply(genomic_seqs, is.null)]

# x <- DNAStringSet(c(os,genomic_seqs))
# 
# 
# x_list <- do.call(rbind,x_list)
#   library(biomaRt)
# listMarts(host = "https://plants.ensembl.org")
# ensembl_plants <- useMart("plants_mart", host = "https://plants.ensembl.org")

# # Connect to Ensembl plants (change to "ensembl" for animal datasets)
# ensembl_rice <- useMart("plants_mart", dataset = "osativa_eg_gene", host = "https://plants.ensembl.org")
# # ensembl_maize <- useMart("plants_mart", dataset = "zmays_eg_gene", host = "https://plants.ensembl.org")
# # ensembl_bvulg <- useMart("plants_mart", dataset = "bvulgaris_eg_gene", host = "https://plants.ensembl.org")
# # ensembl_sbic <- useMart("plants_mart", dataset = "sbicolor_eg_gene", host = "https://plants.ensembl.org")
# # ensembl_taes <- useMart("plants_mart", dataset = "taestivum_eg_gene", host = "https://plants.ensembl.org")
# 
# 
# # Example: Get orthologues from rice to maize
# 
# target_species <- c("athaliana", "tcacao","zmays", "bdistachyon", "sbicolor",
#                     "scereale","sitalica", "taestivum","hvulgare",
#                     "oglaberrima", "macuminata","oglumipatula")
# 
# 
# 
# # Add rice base attributes
# attributes <- c("ensembl_gene_id", "external_gene_name", paste0(target_species,"_eg_homolog_ensembl_gene"))
# 
# # Retrieve ortholog relationships
# orthologs_multi <- getBM(attributes = attributes, mart = ensembl_rice)
# 


DNA_Seq <- readDNAStringSet(paste0(seq_dir,"/","seqs/","seqdump.fasta"))
#Orient Nucleotides
DNA_Seq <- DECIPHER::OrientNucleotides(DNA_Seq)
#Aligning sequences using DECIPHER
aligned <- DECIPHER::AlignSeqs(DNA_Seq)
#adjust alignment adjusting Gap Placements
aligned <- DECIPHER::AdjustAlignment(aligned)

masked_alignment  <- DECIPHER::MaskAlignment(aligned, 
                                            type = "sequences",
                                            correction = T,
                                            showPlot = F)
masked_alignment <- as(masked_alignment, "DNAStringSet")

aligned_v <- DECIPHER::RemoveGaps(masked_alignment, 
                                             removeGaps = "common",
                                             processors = 2)

# BrowseSeqs(aligned_v)
#Writing alignment
Biostrings::writeXStringSet(aligned,file=paste0(seq_dir,"/seqs/","Aligned.fasta"))
#Reading new alignment using ape to be used in ape and Phangorn
dna <- ape::read.dna(paste0(seq_dir,"/seqs/","Aligned.fasta"), format="fasta")
# 
# # counts_Seq <- as.data.frame(DNA_Seq@ranges) #Counting samples
# #Deleting low complex regions using gblocks
# Gblocks_dir <- "D:/REPO_GITHUB/EVOL_GENETICS/Semana7/Gblocks_0.91b/Gblocks.exe"
# blocks <- ips::gblocks(dna,b1=0.5,b2=0.5,b3=10,b4=5,b5="h", exec= Gblocks_dir)
# #Writing cleaned DNA alignment
# write.dna(blocks,format = "fasta",file = paste0(seq_dir,"/","ASVs_GBlocks.fasta"))
#Converting to phyDat object to be used in phangorn
blocks_phyDat <- phangorn::phyDat(dna, type = "DNA", levels = NULL,)
#Calculating best Nucleotide Substitution model
modelTest_phy <-phangorn::modelTest(blocks_phyDat,multicore=T,mc.cores=4);gc()
saveRDS(modelTest_phy,paste0(seq_dir,"/seqs/","modelTest.RDS"))
#Calculating pairwise distancces using the substitution model
dna_dist <- phangorn::dist.ml(blocks_phyDat, model=modelTest_phy$Model[1])
#Calculating pre-existing Neiborghjoining file to optimize
treeNJ <- NJ(dna_dist)
#saving NJ results
phy <- list(blocks_phyDat,dna_dist,treeNJ);saveRDS(phy,paste0(seq_dir,"/seqs/","phy.RDS"))
#Maximum Likelihood tree
fit = pml(treeNJ, data=blocks_phyDat)
#Optimizing maximum likelihood
fitJC <- optim.pml(fit, model=modelTest_phy$Model[1],pml.control(trace = 0),rearrangement = "NNI")
#logLik(fitJC) Log ML of the tree
#Bootstrap using 100 replicates to validate results
bs = bootstrap.pml(fitJC, bs=100, optNni=TRUE, control = pml.control(trace = 0))
cnet <- consensusNet(bs, p=0.2)
# plot(cnet, "2D", show.edge.label=TRUE) #Plots
#Joining ML tree with Bootstrap results
tree <-  plotBS(fit$tree, bs) 
ss <- list(tree,bs,cnet,fitJC)
#Saving results
saveRDS(ss,paste0(seq_dir,"/seqs/","phy_final.RDS"))
ss <-  readRDS(paste0(seq_dir,"/seqs/","phy_final.RDS"))
#Saving tree to be used in Phyloseq R package
write.tree(tree,paste0(seq_dir,"/seqs/","pml.tree")) 
