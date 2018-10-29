library(lhs)

# draw a Latin Hypercube with 10000 samples and 5 variables from unif(0,1).
X<-randomLHS(10000,4)
Y<-matrix(data=NA,nrow=10000,ncol=5)

# transform the Latin hypercube to the distributions of the variables
Y[,1]=sample(14:32,10000,replace=TRUE) #HIV seed
Y[,2]=qunif(X[,1],min=-3.65,max=-1.34) #hivtransmission.param.a
Y[,3]=qunif(X[,2],min=0,max=1.4) #hivtransmission.param.e1
Y[,4]=qunif(X[,3],min=0,max=1.4) #hivtransmission.param.e2
Y[,5]=qunif(X[,4],min=0.7,max=1.4)     #hivtransmission.param.f1