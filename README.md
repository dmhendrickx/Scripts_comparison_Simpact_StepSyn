### Scripts_comparison_Simpact_StepSyn

#### This repository contains 
#### - the R scripts used to fit the StepSyn and Simpact models 
#### - the simulated data (HIV prevalences and cumulative HIV incidences)
####   rows: simulations; columns: time points
#### The scripts are based on the fitting procedure described in
#### Castro Sanchez AY, Aerts M, Shkedy Z, Vickerman P, Faggiano F, Salamina G, et al. 
#### A mathematical model for HIV and hepatitis C co-infection and its assessment from a statistical perspective. 
#### Epidemics. 2013;5(1):56-66.
#### See also PhD thesis Amparo Yovanna Castro Sánchez, Chapter 7:
#### https://ibiostat.be/publications/phd/amparoyovannacastrosanchez.pdf
#### -----------------------------------------------------------------------------------------------------------------------------------
#### The scripts in this repository are for iteration 1 of the fitting procedure.
#### For running the next iterations, update the lower and upper bounds of the parameters in latin_hypercube.R
#### -----------------------------------------------------------------------------------------------------------------------------------
#### Required - parameter fitting Simpact and StepSyn
#### - CRAN packages: lhs, ggplot2, mgcv, lattice, minerva
#### - ARF package (to run with R 2.3.1): https://sites.rutgers.edu/javier-cabrera/research/
#### Required - Simpact fitting only
#### - Simpact program: http://www.simpact.org/
#### - readthedata.R from RSimpactHelp repository: https://github.com/wdelva/RSimpactHelp
#### Required - StepSyn fitting only
#### - StepSyn program: To become Open Access and freely available after publication of a manuscript in preparation
#### -----------------------------------------------------------------------------------------------------------------------------------
































