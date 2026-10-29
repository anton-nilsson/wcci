*================PREDICTED WEIGHT/BMI AND WEIGHT TRAJECTORY PLOTS==============*

*Author:Anton Nilsson
*Date:2026-10-29
*Stata version: 19

*File 4

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

**Weight

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Analysis in different samples
foreach filename in males3 females3{
	use `filename'.dta, clear
	
	*Center age at 17
	gen agec = age-17
	
	*Create natural cubic splines
	mkspline nat4 = agec, cubic nknots(4) displayknots
	*Save knots
	local knots = ""
	mata: st_local("knots", invtokens(strofreal(st_matrix("r(knots)"))))
	
	*LMM with natural cubic splines
	mixed weight i.weightm 1.cohort nat4*||id:agec, cov(unstr)
	predict re_slope_weight re_int_weight, reffects
	egen id_tag=tag(id)
	gen slope_unique=re_slope_weight if id_tag==1
	xtile traj_q_weight = slope_unique, nq(5)
	bysort id (traj_q_weight): replace traj_q_weight = traj_q_weight[1] if traj_q_weight==.
	label var traj_q_weight "Weight trajectories in quintiles"
	label def traj_q_weight_lbl 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
	label val traj_q_weight traj_q_weight_lbl
	tab traj_q_weight, m

	** Fitted weight and trajectory plots
	
	*Only keep relevant variables
	keep id traj_q_weight re_slope_weight re_int_weight mheight
	
	*Have one observation per age 17-60
	sort id
	drop if id==id[_n+1]
	expand 44
	bysort id: gen agec = _n-1
	
	*Recreate splines given these ages (based on output from mkspline above)
	mkspline nat4 = agec, cubic knots("`knots'")

	*Set weight measurement to "objective"
	gen weightm=1
	
	*Set cohort to not be from Birth Register
	gen cohort=0
	
	*Predict weight for everyone and every age
	predict fitted_xb, xb
	gen fitted_weight = fitted_xb + re_int_weight + agec*re_slope_weight

	*Overall weight change, by quintile
	bysort id (agec): gen wd = fitted_weight[_N]-fitted_weight[1]
	sum wd, de
	bysort traj_q_weight: sum wd
	
	save `filename'_fitted.dta
	
	*Predicted BMI and obesity
	gen fitted_BMI = fitted_weight/(mheight/100)^2
	gen fitted_obes = fitted_BMI>=30 & fitted_BMI!=.
	
	*Actual age
	gen age = agec+17
	
	**Obesity onset
	sort id age
	gen first_fitted_obes = fitted_obes==1 & (age==17 | (age>17 & fitted_obes[_n-1]==0))

	bysort id: egen ever_obes = sum(first_fitted_obes)

	bysort id (first_fitted_obes): gen age_obes_onset = age[_N] if ever_obes==1
	sort id age

	egen age_obes_onset_cat = cut(age_obes_onset), at(0 17 30 45 61)
	replace age_obes_onset_cat = 99 if age_obes_onset_cat==.

	sort id age
	keep if id!=id[_n-1]
	
	keep id age_obes_onset age_obes_onset_cat
	
	save `filename'_fitted_obes_onset.dta, replace

	use `filename'_fitted.dta, clear

	**Trajectory plots for median weight
	
	*Create median predicted weight by age and trajectory quintile
	bysort agec: egen median_fitted_weight_q1 = median(fitted_weight) if traj_q_weight==1
	bysort agec: egen median_fitted_weight_q2 = median(fitted_weight) if traj_q_weight==2
	bysort agec: egen median_fitted_weight_q3 = median(fitted_weight) if traj_q_weight==3
	bysort agec: egen median_fitted_weight_q4 = median(fitted_weight) if traj_q_weight==4
	bysort agec: egen median_fitted_weight_q5 = median(fitted_weight) if traj_q_weight==5
	bysort agec: egen median_fitted_weight = median(fitted_weight)
	*Remove missings:
	bysort agec (median_fitted_weight_q1): replace median_fitted_weight_q1 = median_fitted_weight_q1[1]
	bysort agec (median_fitted_weight_q2): replace median_fitted_weight_q2 = median_fitted_weight_q2[1]
	bysort agec (median_fitted_weight_q3): replace median_fitted_weight_q3 = median_fitted_weight_q3[1]
	bysort agec (median_fitted_weight_q4): replace median_fitted_weight_q4 = median_fitted_weight_q4[1]
	bysort agec (median_fitted_weight_q5): replace median_fitted_weight_q5 = median_fitted_weight_q5[1]
	bysort agec (median_fitted_weight): replace median_fitted_weight = median_fitted_weight[1]
	*Only keep one observation per age:
	keep if agec!=agec[_n+1]
	label variable median_fitted_weight "Overall"
	label variable median_fitted_weight_q1 "Quintile 1"
	label variable median_fitted_weight_q2 "Quintile 2"
	label variable median_fitted_weight_q3 "Quintile 3"
	label variable median_fitted_weight_q4 "Quintile 4"
	label variable median_fitted_weight_q5 "Quintile 5"
	 
	if("`filename'" == "males3"){
		local titlename = "Males"
	}
	
	if("`filename'" == "females3"){
		local titlename = "Females"
	}
		
	twoway (scatter median_fitted_weight_q1 age, title("`titlename'") xlab(20(10)60,nogrid) ylab(50(10)100,nogrid) ymtick(50 60 70 80 90 100) xtitle("Age (years)") ytitle("Median predicted weight (kg)") lpattern(line) lcolor(black) msymbol(none) connect(l) yscale(range(60 100))) (scatter median_fitted_weight_q2 age, lpattern(dash_dot) lcolor(black) msymbol(none) connect(l)) (scatter median_fitted_weight_q3 age, lwidth(thick) lpattern(solid) lcolor(black) msymbol(none) connect(l)) (scatter median_fitted_weight_q4 age, lpattern(shortdash) lcolor(black) msymbol(none) connect(l)) (scatter median_fitted_weight_q5 age, lpattern(longdash) lcolor(black) msymbol(none) connect(l) legend(order(5 4 3 2 1))) 
	graph export "Results\median_pred_weight_`filename'.jpg", as(jpg) name("Graph") quality(100) replace

	save `filename'_fitted2median_weight.dta
		
}