##==============================================================================
## single_simulation.R
##
## Questions? Tony Wong (anthony.e.wong@colorado.edu)
##==============================================================================

rm(list=ls())

setwd('~/codes/co2multimodal/R')
library(sn)

##==============================================================================
## Preliminary model and data set-up

dist <- 'sn'
DO_SAMPLE_TVQ <- TRUE
USE_LENTON_FSR <- FALSE
USE_ROYER_FSR <- TRUE

# upper bound from Royer et al 2014 (should be yielding a failed run anyhow)
# lower bound relaxed in light of additional proxy data
upper_bound_co2 <- 50000
lower_bound_co2 <- 0

data_to_assim <- cbind( c("paleosols" , TRUE),
                        c("alkenones" , TRUE),
                        c("stomata"   , TRUE),
                        c("boron"     , TRUE),
                        c("liverworts", TRUE) )

filename.calibinput <- '../input_data/GEOCARB_input_summaries_calib_unc.csv'

source('parameterSetup.R')
source('geocarb.R')
source('run_geocarbF.R') # version with extra `var` uncertainty statistical parameter
source('fitLikelihoodSurface.R')
source('likelihood.R')

# Get model parameter prior distribution bounds
names <- as.character(input$parameter)
bound_lower <- rep(NA, length(names))
bound_upper <- rep(NA, length(names))

ind_neg_inf <- which(input[,'lower_limit']=='_inf')
bound_lower[ind_neg_inf] <- -Inf
bound_lower[setdiff(1:length(names), ind_neg_inf)] <- as.numeric(as.character(input$lower_limit[setdiff(1:length(names), ind_neg_inf)]))
bound_upper <- input$upper_limit

bounds <- cbind(bound_lower, bound_upper)
rownames(bounds) <- as.character(input$parameter)

# only actually need the calibration parameters' bounds, so reformat the bounds
# array to match the vector of calibration parameters
bounds_calib <- mat.or.vec(nr=length(parnames_calib), nc=2)
colnames(bounds_calib) <- c('lower','upper')
rownames(bounds_calib) <- parnames_calib
for (i in 1:length(parnames_calib)) {
  bounds_calib[i,'lower'] <- bounds[parnames_calib[i],'bound_lower']
  bounds_calib[i,'upper'] <- bounds[parnames_calib[i],'bound_upper']
}


##==============================================================================
## Example: Run a single simulation

# par_calib0 is the central estimates from prior distributions. standard
# parameter values, but not calibrated or anything.

model_out <- geocarb(par_calib=par_calib0,
                     par_fixed=par_fixed0,
                     parnames_calib=parnames_calib,
                     parnames_fixed=parnames_fixed,
                     parnames_time=parnames_time,
                     age=age,
                     ageN=ageN,
                     ind_const_calib=ind_const_calib,
                     ind_time_calib=ind_time_calib,
                     ind_const_fixed=ind_const_fixed,
                     ind_time_fixed=ind_time_fixed,
                     ind_expected_time=ind_expected_time,
                     ind_expected_const=ind_expected_const,
                     iteration_threshold=iteration_threshold,
                     do_sample_tvq=DO_SAMPLE_TVQ,
                     par_time_center=par_time_center,
                     par_time_stdev=par_time_stdev)


##==============================================================================
## Example: Evaluate the log-posterior score (log-prior + log-likelihood)
##  for that simulation.

# Note that this is using ALL 58 of the time-steps. We will want to only use
# the t = 240 Mya (million years ago) time slice.

# The log_post(...) function is defined in the likelihood.R routine

lpost_out <- log_post(par_calib=par_calib0,
                      par_fixed=par_fixed0,
                      parnames_calib=parnames_calib,
                      parnames_fixed=parnames_fixed,
                      parnames_time=parnames_time,
                      age=age,
                      ageN=ageN,
                      ind_const_calib=ind_const_calib,
                      ind_time_calib=ind_time_calib,
                      ind_const_fixed=ind_const_fixed,
                      ind_time_fixed=ind_time_fixed,
                      input=input,
                      time_arrays=time_arrays,
                      bounds_calib=bounds_calib,
                      data_calib=data_calib,
                      ind_mod2obs=ind_mod2obs,
                      ind_expected_time=ind_expected_time,
                      ind_expected_const=ind_expected_const,
                      iteration_threshold=iteration_threshold,
                      n_shard=1,
                      loglikelihood_smoothed=loglikelihood_smoothed,
                      likelihood_fit=likelihood_fit,
                      idx_data=idx_data,
                      do_sample_tvq=DO_SAMPLE_TVQ,
                      par_time_center=par_time_center,
                      par_time_stdev=par_time_stdev)

##==============================================================================
## End
##==============================================================================
