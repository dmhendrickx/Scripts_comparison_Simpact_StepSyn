#Script for running Simpact simulations - run on HPC cluster
#e.g. for 100 simulations to be saved in subdirectory sim_1_100
#start=1, end = 100, subdir = sim_1_100
#---------------------------------------------------------------

simpact_sim<-function(start,end,subdir){
maindir<-"[PATH_TO_WORK_DIRECTORY_ON_HPC_CLUSTER]"
setwd(file.path(maindir))
library(RSimpactCyan)
load("workspace_LHS.RData")# output latin_hypercube.R
source('readthedata.R', encoding = 'UTF-8')

dir.create(file.path(maindir,subdir))
destdir<-file.path(maindir,subdir)
setwd(file.path(destdir))

cfg <- list()
cfg["population.simtime"] <- 35
cfg["birth.boygirlratio"] <- 0.54
cfg["population.nummen"] <- 2500
cfg["population.numwomen"] <- 2092
cfg["chronicstage.acutestagetime"] <- 12/52
cfg["hivseed.time"] <- 10
cfg["mortality.aids.survtime.k"] <- 0
cfg["mortality.aids.survtime.C"] <- 2
cfg["aidsstage.start"] <- 1 
cfg["person.vsp.toacute.x"]<-4.555
cfg["monitoring.cd4.threshold"]<-0
cfg["formationmsm.hazard.agegap.baseline"]<-0
cfg["dissolutionmsm.alpha_0"]<-0
cfg["hivseed.type"]<- "amount"
cfg["person.survtime.logoffset.dist.type"]<-"discrete.csv.twocol"
cfg["person.survtime.logoffset.dist.discrete.csv.twocol.file"]<-"[PATH_TO_WORK_DIRECTORY_ON_HPC_CLUSTER]/distr.csv"
cfg["person.hsv2.a.dist.type"]<-"fixed"
cfg["person.hsv2.a.dist.fixed.value"]<--2.550
cfg["hsv2transmission.hazard.b"]<--0.12
cfg["hsv2transmission.hazard.c"]<-0.694
cfg["hivtransmission.param.b"]<-0
cfg["hivtransmission.param.c"]<-0
cfg["hsv2seed.time"]<-10
cfg["hsv2seed.fraction"]<-0.25
cfg["mortality.normal.weibull.scale"]<-600 # no mortality
cfg["birth.pregnancyduration.dist.fixed.value"]<-36 # no natality
cfg["hivtransmission.maxageref.diff"]<-Inf
cfg["population.maxevents"]<-cfg$population.simtime*cfg$population.nummen*15 #If 15 events happen per person per year, something's wrong.

#Start the clock
start.time <- Sys.time()
res <- list()
datalist <- list()
not_NA <-vector(mode = "logical",length=end)

for (i in start:end){
  set.seed(12345)
  cfg["hivseed.amount"]<-Y[i,1]
  cfg["hivtransmission.param.a"]<-Y[i,2]
  cfg["hivtransmission.param.e1"]<-Y[i,3]
  cfg["hivtransmission.param.e2"]<-Y[i,4]
  cfg["hivtransmission.param.f1"]<-Y[i,5]
  res_new <- try(simpact.run(cfg,file.path(destdir),identifierFormat = "%T-%r%r%r%r%r%r%r%r"))
  if (class(res_new) != "try-error"){
    not_NA[i]="TRUE"
    datalist_new<-readthedata(res_new)
    datalist<-append(datalist,list(datalist_new))
    unlink(res_new$loglocation)
    unlink(res_new$outputfile)
    unlink(res_new$logtreatments)
    unlink(res_new$logpersons)
    unlink(res_new$logviralloadhiv)
    unlink(res_new$configfile)
    unlink(res_new$logevents)
    unlink(res_new$logrelations)
    unlink(res_new$logsettings)
    assign("not_NA",not_NA,.GlobalEnv)
    assign("datalist",datalist,.GlobalEnv)
    save.image("workspace_Simpact.RData")
  } 
}  
  
assign("not_NA",not_NA,.GlobalEnv)
assign("datalist",datalist,.GlobalEnv)
save.image("workspace_Simpact.RData")

# Stop the clock
end.time <- Sys.time()
time.taken <- end.time - start.time
}