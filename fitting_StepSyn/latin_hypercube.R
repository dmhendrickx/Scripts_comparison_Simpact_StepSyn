library(lhs)

# draw a Latin Hypercube with 10000 samples and 4 variables from unif(0,1).
X<-randomLHS(10000,4)

# transform the Latin hypercube to the distributions of the variables
Y=matrix(0,nrow=10000,ncol=4)
Y[,1]=qunif(X[,1],min=0.001,max=0.02) #hiv.tr.prob.m2f.baseline
Y[,2]=qunif(X[,2],min=0.25,max=0.5) #hiv.tr.prob.baseline.f.m.ratio
Y[,3]=qunif(X[,3],min=1,max=4) #hiv.tr.prob.baseline.mult.hsv2.chronic.index
Y[,4]=qunif(X[,4],min=1,max=4) #hiv.tr.prob.baseline.mult.hsv2.chronic.exposed
