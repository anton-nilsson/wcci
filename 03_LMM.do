*================LMM FOR LIFE SPAN AND AGE SPAN ===============================*

*Author:Anton Nilsson
*Date:2026-10-29
*Stata version: 19

*File 3

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Analysis in six different samples
foreach filename in males3 females3 males2 females2 males3_objective_only females3_objective_only{
	use `filename'.dta, clear
	
	*Center age at 17
	gen agec = age-17
	
	*Create natural cubic splines
	mkspline nat4 = agec, cubic nknots(4) displayknots

	*Create linear splines
	mkspline age1 13 age2 28 age3 = agec
	
	**Models for weight
	
	*LMM with natural cubic splines for lifespan analysis
	mixed weight i.weightm 1.cohort nat4*||id:agec, cov(unstr)
	predict re_slope_weight re_int_weight, reffects
	gen weight_intercept = _b[_cons] + re_int_weight
	predict fitted_weight, fitted
	egen id_tag=tag(id)
	gen slope_unique=re_slope_weight if id_tag==1
	xtile traj_q_weight = slope_unique, nq(5)
	bysort id (traj_q_weight): replace traj_q_weight = traj_q_weight[1] if traj_q_weight==.
	label var traj_q_weight "Weight trajectories in quintiles"
	label def traj_q_weight_lbl 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
	label val traj_q_weight traj_q_weight_lbl
	tab traj_q_weight, m
	drop id_tag slope_unique
	
	*LMM with linear splines for agespan analysis
	mixed weight i.weightm 1.cohort c.(age1 age2 age3) || id: age1 age2 age3, cov(unstr)
	predict re2_slope1_weight re2_slope2_weight re2_slope3_weight re2_int_weight, reffects
	gen weight_slope_1 =_b[age1] + re2_slope1_weight
	gen weight_slope_2 =_b[age2] + re2_slope2_weight
	gen weight_slope_3 =_b[age3] + re2_slope3_weight
	gen weight_intercept_age=_b[_cons] + re2_int_weight
	
	** Models for BMI
	
	mixed bmi i.weightm 1.cohort nat4*||id:agec, cov(unstr)
	predict re_slope_bmi re_int_bmi, reffects
	gen bmi_intercept = _b[_cons] + re_int_bmi
	predict fitted_bmi, fitted
	egen id_tag=tag(id)
	gen slope_unique=re_slope_bmi if id_tag==1
	xtile traj_q_bmi = slope_unique, nq(5)
	bysort id (traj_q_bmi): replace traj_q_bmi = traj_q_bmi[1] if traj_q_bmi==.
	label var traj_q_bmi "BMI trajectories in quintiles"
	label def traj_q_bmi_lbl 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
	label val traj_q_bmi traj_q_bmi_lbl
	tab traj_q_bmi, m
	drop id_tag slope_unique
	
	save `filename'_LMM.dta
	
}


