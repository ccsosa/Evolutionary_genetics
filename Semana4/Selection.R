require(learnPopGen)
selection(w=c(0.7,1,0.8),time=500)


selection(w=c(1.0,1.0,0.8),time=500,show="surface")
mutation.selection(
  p0=0.2, 
  w=c(0.6,0.2), 
  u=0.001, 
  time=500, 
  show="", pause=0, 
                  ylim=c(0,1))
