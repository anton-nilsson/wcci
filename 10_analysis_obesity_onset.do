*=================================ANALYSIS=====================================*

*Age of obesity obset (established obesity-related cancers)

*Author: Anton Nilsson
*Date: 2026-10-28
*Stata version: 19

*File 10

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Established obesity-related cancers to analyze in males:
local varlist_males "any_cancer any_ob_est_cancer cancer_detail_cat11 cancer_detail_cat14 cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat12 cancer_middle_cat14 cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat52 "
*Established obesity-related cancers to analyze in females:
local varlist_females "any_cancer any_ob_est_cancer cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat14 pm_breast_cancer cancer_detail_cat41 cancer_middle_cat25  cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat38 cancer_middle_cat52 "

foreach sex in males females{
	
	use `sex'3_lmm_bl, clear
	
	merge 1:1 id using `sex'3_fitted_obes_onset
	keep if _merge==3
	drop _merge

	estimates clear
	foreach name of local varlist_`sex'{
		
		if "`name'"!="pm_breast_cancer" & "`name'"!="cancer_detail_cat41" {
			stset dox, enter(fu_start1_58) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="pm_breast_cancer"{
			capture drop turning55
			gen turning55 = mdy(1,1,yob+55)
			capture drop fu_start1_postmen_breast
			gen fu_start1_postmen_breast = max(fu_start1_58,turning55)
			stset dox, enter(fu_start1_postmen_breast) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="cancer_detail_cat41"{
			stset dox, enter(fu_start1_93) failure(`name') origin(dob) scale(365.25)
		}
		
		stcox b99.age_obes_onset_cat b3.education b1.birth_country ///
						  b2.marital_status b2.current_smoker c.mheight, strata(bcohort)
		estimates store `name'
	}
	
	
	*Estimation table for lifespan
	etable, est("`varlist_`sex''") /// 
	column(estimates) 													///
	cstat(_r_b, nformat(%3.2f)) 										/// 
	cstat(_r_ci, cidelimiter("-") sformat("(%s)") nformat(%3.2f)) 		/// 
	mstat(N_sub, nformat(%9.0fc) label("No. of participants")) 			/// 
	mstat(N_fail, nformat(%9.0fc) label("No. of events")) 				/// 
	title(Life span weight trajectories in quintiles and outcomes)		///
	export(Results\obes_onset_`sex'.xls, modify)
}

