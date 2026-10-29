*================KEEP BASELINE OBSERVATION FOR SURVIVAL ANALYSIS===============*

*Author: Anton Nilsson
*Date: 2026-10-23
*Stata version: 19

*File 5

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

foreach filename in males3_lmm females3_lmm males2_lmm females2_lmm males3_objective_only_lmm females3_objective_only_lmm{

	use `filename'.dta, clear
	
	*Only keep third observation (or second, depending on sample)
	bysort id (dat_study): gen obs_no = _n
	
	if "`filename'" == "males3_lmm" | "`filename'" == "females3_lmm" | "`filename'" == "males3_objective_only_lmm" | "`filename'" == "females3_objective_only_lmm"{
		keep if obs_no == 3
	}
	
	if "`filename'" == "males2_lmm" | "`filename'" == "females2_lmm"{
		keep if obs_no == 2
	}
	
	drop obs_no 

	*Start follow-up after 1 year 
	gen fu_start1 = dat_study+365.25
	gen fu_years1 = (dox-fu_start1)/365.25
	*Not start until data from Cancer Register becomes available (in practice, no start date is earlier):
	gen fu_start1_58 = max(mdy(1,1,1958),fu_start1)
	gen fu_years1_58 = (dox-fu_start1_58)/365.25
	*Later possible start dates
	gen fu_start1_87 = max(mdy(1,1,1987),fu_start1)
	gen fu_start1_93 = max(mdy(1,1,1993),fu_start1)
	gen fu_start1_05 = max(mdy(1,1,2005),fu_start1)
	gen fu_years1_87 = (dox-fu_start1_87)/365.25
	gen fu_years1_93 = (dox-fu_start1_93)/365.25
	gen fu_years1_05 = (dox-fu_start1_05)/365.25	
	
	*Change weights to desired scales
	gen weight_intercept_5kg = weight_intercept/5
	gen weight_intercept_age_5kg = weight_intercept_age/5
	gen weight_slope_1_05kg = weight_slope_1*2
	gen weight_slope_2_05kg = weight_slope_2*2
	gen weight_slope_3_05kg = weight_slope_3*2
	
	*Start of follow-up for postmenopausal breast cancer
	gen turning55 = mdy(1,1,yob+55)
	capture drop fu_start1_postmen_breast
	gen fu_start1_postmen_breast = max(fu_start1_58,turning55)

	*Count cancers (established)
	foreach name in any_cancer any_ob_est_cancer cancer_detail_cat11 cancer_detail_cat14 cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat12 cancer_detail_cat101 cancer_middle_cat14 pm_breast_cancer cancer_detail_cat41 cancer_middle_cat25 cancer_middle_cat33 cancer_middle_cat38 cancer_middle_cat52 cancer_middle_cat31{
		disp "`name'"
		count if `name'==1
	}
	
	*Count numbers (potential)
	foreach name in cancer_middle_cat1 cancer_middle_cat4 cancer_morphology_cat6 cancer_morphology_cat23 cancer_middle_cat9 bill_cancer_excl_gb cancer_middle_cat18 cancer_middle_cat27 cancer_middle_cat37 cancer_middle_cat39 cancer_middle_cat40 cancer_middle_cat41 cancer_middle_cat48 hodgkins cancer_detail_cat86 cancer_detail_cat87 cancer_detail_cat88 cancer_detail_cat89 cancer_detail_cat90 cancer_detail_cat92 cancer_detail_cat93 cancer_detail_cat94  cancer_morphology_cat7 cancer_morphology_cat15 cancer_middle_cat21 cancer_detail_cat39{
	disp "`name'"
		count if `name'==1
	}
	
	*Save
	save `filename'_bl.dta

}



