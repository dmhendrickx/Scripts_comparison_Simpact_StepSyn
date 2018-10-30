#Copy the folders with your simulations from the HPC cluster to #your computer.
#This script is an example for 10000 simulations stored in 10 
#folders.
#The script extracts the input for the parameter fitting from the
#output files of the simulations and then performs the parameter #fitting procedure.
#----------------------------------------------------------------

#read the data
zresweekPrSTDs<-list()
setwd("[PATH_TO_WORK_DIRECTORY]/sim_1_1000")
for (i in 1:1000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_1001_2000")
for (i in 1001:2000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_2001_3000")
for (i in 2001:3000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_3001_4000")
for (i in 3001:4000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_4001_5000")
for (i in 4001:5000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_5001_6000")
for (i in 5001:6000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_6001_7000")
for (i in 6001:7000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_7001_8000")
for (i in 7001:8000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_8001_9000")
for (i in 8001:9000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}
setwd("[PATH_TO_WORK_DIRECTORY]/sim_9001_10000")
for (i in 9001:10000){
  print(i)
  zresweekPrSTDs_new<-read.csv(paste0("zresWeekPrSTDs",i,".result"),sep="")
  zresweekPrSTDs<-append(zresweekPrSTDs,list(zresweekPrSTDs_new))
  assign("zresweekPrSTDs",zresweekPrSTDs,.GlobalEnv)
}

#yearly prevalence HIV
prevalence_males=matrix(data=NA,nrow=10000,ncol=26)
prevalence_females=matrix(data=NA,nrow=10000,ncol=26)

for (j in 1:10000){
  prevalence_males[j,1]=zresweekPrSTDs[[j]]$males.p.hiv.str1[1]
  prevalence_females[j,1]=zresweekPrSTDs[[j]]$females.p.hiv.str1[1]
  
  for (i in 1:25){
    prevalence_males[j,i+1]=zresweekPrSTDs[[j]]$males.p.hiv.str1[52*i]
    prevalence_females[j,i+1]=zresweekPrSTDs[[j]]$females.p.hiv.str1[52*i]
  }
} #end for j in 1:10000

#prevalence HSV2 females in 1997
hsv2_females=vector(mode = "numeric",length=10000)
for (j in 1:10000){
hsv2_females[j]=zresweekPrSTDs[[j]]$females.p.hsv2[52*17]
} 

rm(zresweekPrSTDs,zresweekPrSTDs_new)
save.image("[PATH_TO_WORK_DIRECTORY]/workspace_fitting.RData")

males<-c(0.497,0.928,1.481,1.342,0.918,2.111,1.915,3.383,4.100,3.876)
females<-c(0.946,1.765,2.818,2.553,1.746,4.015,3.643,6.435,7.800,7.374)
hsv2_real=50.8
males_est<-prevalence_males[9:18]
females_est<-prevalence_females[9:18]
time<-seq(1989,1998,by=1)

rel_diff_ssq_m=vector(mode="numeric",length=10000)
rel_diff_ssq_f=vector(mode="numeric",length=10000)
rel_diff_ssq=vector(mode="numeric",length=10000)

for (k in 1:10000){
  estim_m=prevalence_males[k,9:18]
  estim_f=prevalence_females[k,9:18]
  rel_diff_ssq_m[k]=sum(((males-estim_m)^2)/(males^2))
  rel_diff_ssq_f[k]=sum(((females-estim_f)^2)/(females^2)) + ((hsv2_real-hsv2_females[k])^2)/(hsv2_real^2)
  rel_diff_ssq[k]=rel_diff_ssq_m[k]+rel_diff_ssq_f[k]
}

#best solution
best=min(rel_diff_ssq)
best_index=which(rel_diff_ssq==best)
load("[PATH_TO_WORK_DIRECTORY]/workspace_LHS.RData")
best_par=Y[best_index,]

#univariate analysis - smoothed density plots
indices_rel <- which(rel_diff_ssq < quantile(rel_diff_ssq,prob=0.01,na.rm=TRUE))
baseline<-Y[,1]
fm_ratio<-Y[,2]
hsv2_index<-Y[,3]
hsv2_exposed<-Y[,4]
baseline_1pc<-baseline[indices_rel]
fm_ratio_1pc<-fm_ratio[indices_rel]
hsv2_index_1pc<-hsv2_index[indices_rel]
hsv2_exposed_1pc<-hsv2_exposed[indices_rel]

library(ggplot2)

d<-data.frame(x=Y[,1])
d2<-data.frame(x=baseline_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "baseline")
p2<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=Y[,2])
d2<-data.frame(x=fm_ratio_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "fm_ratio")
p2<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=Y[,3])
d2<-data.frame(x=hsv2_index_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hsv2_index")
p2<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

d<-data.frame(x=Y[,4])
d2<-data.frame(x=hsv2_exposed_1pc)
p<-ggplot(data = d, mapping = aes(x = x,linetype=0)) + geom_density(linetype=2)
p1<-p + labs(x = "hsv2_exposed")
p2<-p1 + geom_density(data=d2, mapping = aes(x = x), linetype=1,adjust=2)

#Activity region finder
output_rel<-vector(mode="numeric",length=10000)
output_rel[indices_rel]=1
dataframe_arf<-data.frame(output_rel=output_rel,baseline=baseline,fm_ratio=fm_ratio,hsv2_index=hsv2_index,hsv2_exposed=hsv2_exposed)
rm(list=setdiff(ls(),"dataframe_arf")) 
save.image("workspace_arf.RData")

# In R-2.3.1
# hf.arf = f.arf(output_rel~baseline+fm_ratio+hsv2_index+hsv2_exposed,data=dataframe_arf)
# write.csv(hf.arf$tree,file="ARF1.csv")

#Generalized additive models
library(mgcv)

gammod<-gam(output_rel~s(baseline)+s(fm_ratio)+s(hsv2_index)+s(hsv2_exposed), data=dataframe_arf,
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
  gammod<-gam(output_rel~s(baseline)+s(fm_ratio)+s(hsv2_index)+s(hsv2_exposed), data=dataframe_arf,
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

#AIC minimal 10^0=1, BIC minimal 10^2=100
opt.tuning.scale<-1
opt.sp<-opt.tuning.scale*sp

gammod1<-gam(output_rel~s(baseline)+s(fm_ratio)+s(hsv2_index)+s(hsv2_exposed), data=dataframe_arf,
             family=binomial(link=logit),
             sp=opt.sp)

opt.tuning.scale<-100
opt.sp<-opt.tuning.scale*sp

gammod2<-gam(output_rel~s(baseline)+s(fm_ratio)+s(hsv2_index)+s(hsv2_exposed), data=dataframe_arf,
             family=binomial(link=logit),
             sp=opt.sp)

library(lattice)
library(ggplot2)

pred1<-predict.gam(gammod1,dataframe_arf,type="response")

d=data.frame(x=dataframe_arf$baseline,y=pred1)
p1<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="baseline",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$fm_ratio,y=pred1)
p2<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="fm_ratio",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$hsv2_index,y=pred1)
p3<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hsv2_index",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$hsv2_exposed,y=pred1)
p4<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hsv2_exposed",y="predicted probability of low relative sum of squared errors")

pred2<-predict.gam(gammod2,dataframe_arf,type="response")

d=data.frame(x=dataframe_arf$baseline,y=pred2)
p5<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="baseline",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$fm_ratio,y=pred2)
p6<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="fm_ratio",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$hsv2_index,y=pred2)
p7<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hsv2_index",y="predicted probability of low relative sum of squared errors")

d=data.frame(x=dataframe_arf$hsv2_exposed,y=pred2)
p8<-ggplot(d,aes(x=x,y=y)) + geom_point(alpha=1, color="black") + geom_smooth(alpha=0) + labs(x="hsv2_exposed",y="predicted probability of low relative sum of squared errors")

save.image("workspace_gam.RData")

#caculation MIC
library(minerva)
mine(baseline_1pc,fm_ratio_1pc)
mine(baseline_1pc,hsv2_index_1pc)
mine(baseline_1pc,hsv2_exposed_1pc)

mine(fm_ratio_1pc,hsv2_index_1pc)
mine(fm_ratio_1pc,hsv2_exposed_1pc)

mine(hsv2_index_1pc,hsv2_exposed_1pc)