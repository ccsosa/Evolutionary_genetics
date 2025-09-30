library(learnPopGen)



p0 = 0.5
Ne = 20
nrep = 20
time = 10
#Genetic drift
object <- learnPopGen::genetic.drift(
  p0 = p0,
  Ne = Ne,
  nrep = nrep,
  time = time,
  pause=0.4)
#see genotypes
plot(object,show="genotypes")
#see heterozygosity loss
plot(object,show="heterozygosity")
#see frequencies
plot(object,show="p")

