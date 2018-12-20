#Script for running the model fitting procedure described in 
#Castro Sanchez AY, Aerts M, Shkedy Z, Vickerman P, Faggiano 
#F, Salamina G, et al. A mathematical model for HIV and 
#hepatitis C co-infection and its assessment from a 
#statistical perspective. Epidemics. 2013;5(1):56-66.
#-------------------------------------------------------------
#After copying workspace_analyze_par.RData (output 
#concatenate_par.R) from the HPC cluster, you can run the 
#script on your computer.
#-------------------------------------------------------------

load("[PATH_TO_YOUR_WORK_DIRECTORY]/workspace_analyze_par.RData")

best_estim_rel=min(rel_diff_ssq,na.rm=TRUE)
index_rel=which(rel_diff_ssq==best_estim_rel)
best_hiv_a=hiv_a[index_rel]
best_hiv_e1=hiv_e1[index_rel]
best_hiv_e2=hiv_e2[index_rel]
best_hiv_f1=hiv_f1[index_rel]

#univariate analysis - smoothed density plots 1% best solutions
indices_rel <- which(rel_diff_ssq < quantile(rel_diff_ssq,prob=0.01,na.rm=TRUE))

hiv_a_1pc<-hiv_a[indices_rel]
hiv_e1_1pc<-hiv_e1[indices_rel]
hiv_e2_1pc<-hiv_e2[indices_rel]
hiv_f1_1pc<-hiv_f1[indices_rel]

library(ggplot2)

d<-data.frame(x=hiv_a)
d2<-data.frame(x=hiv_a_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hiv_a") + theme(text = element_text(size=14)) 
p2a<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=hiv_e1)
d2<-data.frame(x=hiv_e1_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hiv_e1") + theme(text = element_text(size=14))
p2b<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=hiv_e2)
d2<-data.frame(x=hiv_e2_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hiv_e2") + theme(text = element_text(size=14))
p2c<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=hiv_f1)
d2<-data.frame(x=hiv_f1_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hiv_f1") + theme(text = element_text(size=14))
p2d<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

multiplot(p2a,p2b,p2c,p2d,cols=2)

#Activity region finder
output_rel<-vector(mode="numeric",length=length(rel_diff_ssq))
output_rel[indices_rel]=1
dataframe_arf<-data.frame(output_rel=output_rel,hiv_a=hiv_a,hiv_e1=hiv_e1,hiv_e2=hiv_e2,hiv_f1=hiv_f1)
rm(list=setdiff(ls(),"dataframe_arf")) 
save.image("workspace_arf.RData")

# In R-2.3.1
# setwd("[PATH_TO_YOUR_WORK_DIRECTORY]")
# load("[PATH_TO_YOUR_WORK_DIRECTORY]/workspace_arf.RData")
# hf.arf = f.arf(output_rel~hiv_a+hiv_e1+hiv_e2+hiv_f1,data=dataframe_arf)
# write.csv(hf.arf$tree,file="ARF1.csv")

#Generalized additive models
library(mgcv)

gammod<-gam(output_rel~s(hiv_a)+s(hiv_e1)+s(hiv_e2)+s(hiv_f1), data=dataframe_arf,
            family=binomial(link=logit))

sp<-gammod$sp
tuning.scale<-c(1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1,1e2,1e3,1e4,1e5)
scale.exponent<-log10(tuning.scale)
n.tuning<-length(tuning.scale)
edf<-rep(NA,n.tuning)
min2ll<-rep(NA,n.tuning)
aic<-rep(NA,n.tuning)
bic<-rep(NA,n.tuning)

for(i in 1:n.tuning){
  gammod<-gam(output_rel~s(hiv_a)+s(hiv_e1)+s(hiv_e2)+s(hiv_f1), data=dataframe_arf,
              family=binomial(link=logit),
              sp=tuning.scale[i]*sp)
  min2ll[i]<- -2*logLik(gammod)
  edf[i]<-sum(gammod$edf)+1
  aic[i]<-AIC(gammod)
  bic[i]<-BIC(gammod)
}

pdf("AICBICmodel1.pdf")
par(mfrow=c(2,2))
plot(scale.exponent,min2ll,type="b",main="-2 log likelihood")
plot(scale.exponent, edf, ylim=c(0,70), type="b", main="effective number of parameters")
plot(scale.exponent, aic, type="b",main="AIC")
plot(scale.exponent, bic, type="b", main="BIC")
dev.off()

#AIC minimal 10^0=1, BIC minimal 10^1=10
opt.tuning.scale<-1
opt.sp<-opt.tuning.scale*sp

gammod1<-gam(output_rel~s(hiv_a)+s(hiv_e1)+s(hiv_e2)+s(hiv_f1), data=dataframe_arf,
             family=binomial(link=logit),
             sp=opt.sp)

opt.tuning.scale<-10
opt.sp<-opt.tuning.scale*sp

gammod2<-gam(output_rel~s(hiv_a)+s(hiv_e1)+s(hiv_e2)+s(hiv_f1), data=dataframe_arf,
             family=binomial(link=logit),
             sp=opt.sp)

library(lattice)
library(ggplot2)

pred1<-predict.gam(gammod1,dataframe_arf,type="response")

d=data.frame(x=dataframe_arf$hiv_a,y=pred1)
p1<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_a",y="predicted probability of low RSSE")
p1<-p1 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_e1,y=pred1)
p2<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_e1",y="predicted probability of low RSSE")
p2<-p2 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_e2,y=pred1)
p3<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_e2",y="predicted probability of low RSSE")
p3<-p3 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_f1,y=pred1)
p4<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_f1",y="predicted probability of low RSSE")
p4<-p4 + theme(text = element_text(size=14))

pred2<-predict.gam(gammod2,dataframe_arf,type="response")

d=data.frame(x=dataframe_arf$hiv_a,y=pred2)
p5<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_a",y="predicted probability of low RSSE")
p5<-p5 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_e1,y=pred2)
p6<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_e1",y="predicted probability of low RSSE")
p6<-p6 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_e2,y=pred2)
p7<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_e2",y="predicted probability of low RSSE")
p7<-p7 + theme(text = element_text(size=14))

d=data.frame(x=dataframe_arf$hiv_f1,y=pred2)
p8<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hiv_f1",y="predicted probability of low RSSE")
p8<-p8 + theme(text = element_text(size=14))

save.image("workspace_gam.RData")

multiplot(p1,p2,p3,p4,cols=2)
multiplot(p5,p6,p7,p8,cols=2)

#maximal information coefficient
library(minerva)
mine(hiv_a_1pc,hiv_e1_1pc)$MIC
mine(hiv_a_1pc,hiv_e2_1pc)$MIC
mine(hiv_a_1pc,hiv_f1_1pc)$MIC

mine(hiv_e1_1pc,hiv_e2_1pc)$MIC
mine(hiv_e1_1pc,hiv_f1_1pc)$MIC

mine(hiv_e2_1pc,hiv_f1_1pc)$MIC

#highest MIC
plot(hiv_a_1pc,hiv_e2_1pc)
plot(hiv_a_1pc,hiv_e1_1pc)
