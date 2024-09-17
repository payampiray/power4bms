# power4bms

This code implements a method for power calculation in Bayesian model selection studies. 

The code has been implemented and tested in MATLAB 2022b, but there is no dependency on any MATLAB toolboxes.

calc_power.m calculates power given sample size (N) and model space size (K).
calc_sample_size.m calculates sample size given the model space size (k) and required power (default is 0.8).
The optional values for functionality of these two routies are set in calc_config.m
These two functions use calc_power_given_true.m and calc_generate_true.m

sim_power_analysis.m and figsupp_sim.m implement simulation analyses related to power (Fig 1 and Supplementary Fig 1)
ffx_equal.m and ffx_winner.m imeplements the two simulation analyses related to fixed effects model selection (Table 1).
review_calc_power.m performs analyses related to the narrative literature review (Fig 2), drawing based .

written by Payam Piray
contact: piray@usc.edu

Note: Python code for calculating power will also be shared with the publication of manuscript.