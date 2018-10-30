#Script for running StepSyn simulations - run on HPC cluster
#e.g. for 1000 simulations to be saved in subdirectory sim_1_1000
#start=1, end = 1000, subdir = sim_1_1000
#-------------------------------------------------------------

StepSyn<-function(start,end,subdir){
  maindir<-"[PATH_TO_WORK_DIRECTORY_ON_HPC_CLUSTER]"
  setwd(file.path(maindir))
  load("workspace_LHS.RData")
  dir.create(file.path(maindir,subdir))
  destdir<-file.path(maindir,subdir)
  for (k in start:end)
  {
    assign("k",k,.GlobalEnv)
    source("sim2.r")
    filename <- paste( "zresWeekPrPopul", as.character(k), ".result", sep="" )
    write.table( weekly.popul, file=file.path(destdir,filename) )
    
    filename <- paste( "zresWeekPrLinks", as.character(k), ".result", sep="" )
    write.table( weekly.links, file=file.path(destdir,filename) )
    
    filename <- paste( "zresWeekPrSTDs", as.character(k), ".result", sep="" )
    write.table( weekly.preval, file=file.path(destdir,filename) )
    
    filename <- paste( "zresQuartIncSTDs", as.character(k), ".result", sep="" )
    write.table( quarterly.incid, file=file.path(destdir,filename) )
  }
}