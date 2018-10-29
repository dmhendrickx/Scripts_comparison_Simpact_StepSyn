
#If your output is stored in different folders, you can 
#apply par_space1.R to each folder and then concatenate the 
#resulting workspaces into one workspace using this script.
#Here, an example is given for 100 folders of 100 simulations.
#-------------------------------------------------------------

setwd("[PATH_TO_WORK_DIRECTORY_ON_HPC_CLUSTER]")

load(paste0("[PATH_TO_WORK_DIRECTORY_ON_HPC_CLUSTER]/sim_1_100/workspace_par.RData"))

prev_HIV_f_estim_new <- prev_HIV_f_estim
prev_HIV_m_estim_new <- prev_HIV_m_estim
prev_HSV2_f_estim_new <- prev_HSV2_f_estim
rel_diff_ssq_new <- rel_diff_ssq
hiv_a_new <- hiv_a
hiv_e1_new <- hiv_e1
hiv_e2_new <- hiv_e2
hiv_f1_new <- hiv_f1

for (i in 2:100){
  print(i)
  load(paste0("[PATH_TO_WORK_DIRECTOTY_ON_HPC_CLUSTER]/sim_",100*i-99,"_",100*i,"/workspace_par.RData"))
  prev_HIV_f_estim_new <- rbind(prev_HIV_f_estim_new,prev_HIV_f_estim)
  prev_HIV_m_estim_new <- rbind(prev_HIV_m_estim_new,prev_HIV_m_estim)
  prev_HSV2_f_estim_new <- c(prev_HSV2_f_estim_new,prev_HSV2_f_estim)
  rel_diff_ssq_new <- c(rel_diff_ssq_new,rel_diff_ssq)
  hiv_a_new <- c(hiv_a_new,hiv_a)
  hiv_e1_new <- c(hiv_e1_new,hiv_e1)
  hiv_e2_new <- c(hiv_e2_new,hiv_e2)
  hiv_f1_new <- c(hiv_f1_new,hiv_f1)
}

rm(prev_HIV_f_estim,prev_HIV_m_estim,prev_HSV2_f_estim,rel_diff_ssq,hiv_a,hiv_e1,hiv_e2,hiv_f1)

assign("prev_HIV_f_estim",prev_HIV_f_estim_new,.GlobalEnv)
assign("prev_HIV_m_estim",prev_HIV_m_estim_new,.GlobalEnv)
assign("prev_HSV2_f_estim",prev_HSV2_f_estim_new,.GlobalEnv)
assign("rel_diff_ssq",rel_diff_ssq_new,.GlobalEnv)
assign("hiv_a",hiv_a_new,.GlobalEnv)
assign("hiv_e1",hiv_e1_new,.GlobalEnv)
assign("hiv_e2",hiv_e2_new,.GlobalEnv)
assign("hiv_f1",hiv_f1_new,.GlobalEnv)

save.image("workspace_analyze_par.RData")