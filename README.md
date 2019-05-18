# co2multimodal

Project to examine a variety of statistical approaches for resolving multimodal behavior in the multimodal
likelihood function.

## A brief tour

* input_data/
  * CO2_Proxy_Foster2017_calib_SN-co2_25Sep2018.csv -- contains the CO2 proxy data for calibration
  * GEOCARB_input_summaries_calib_unc.csv -- prior distribution information for the model parameters
  * GEOCARB_input_arrays_NewDegassing.csv -- input arrays for the time-varying inputs
* fortran/
  * obj/ -- contains the output object from the compiled Fortran model
  * src/ -- contains the Fortran model source code, run_geocarb_unc.f90
  * Makefile -- file to compile the Fortran model
* R/
  * install_packages.R -- install the R packages needed for the model and some statistical calibration packages
  * GEOCARB-2014_getData.R -- load the CO2 proxy data
  * GEOCARB-2014_parameterSetup_tvq.R -- set up the model parameters and their prior distributions
  * GEOCARB_fit_likelihood_surface.R -- fit independent kernel density estimates for the likelihood function at each time step, based on samples from the skew-normal prior distributions
  * GEOCARB-2014_calib_likelihood_unc.R -- contains functions for the prior probability distribution function, the likelihood function and the posterior probability distribution function
  * run_geocarbF_unc.R
  * model_forMCMC_tvq.R
  * single_simulation.R

## Quick-start

To run a single simulation...

todo...

---

Questions? Tony Wong (<anthony.e.wong@colorado.edu>)
