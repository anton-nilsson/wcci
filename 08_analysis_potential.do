*====================================ANALYSIS==================================*

*Potentially obesity-related cancers here

*Author: Anton Nilsson
*Date: 2026-10-28
*Stata version: 19

*File 8

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Potentially obesity-related cancers in males:
local varlist_males "any_ob_pot_cancer cancer_not_est_pot cancer_middle_cat1 cancer_middle_cat9 cancer_middle_cat18 cancer_middle_cat41 cancer_middle_cat48 cancer_detail_cat86 cancer_detail_cat87 cancer_detail_cat89 myeloid"
*Potentially obesity-related cancers in females:
local varlist_females "any_ob_pot_cancer cancer_not_est_pot cancer_morphology_cat7 cancer_detail_cat39 cancer_middle_cat40 cancer_middle_cat41 cancer_detail_cat86 myeloid"

foreach sex in males females{
	use `sex'3_lmm_bl.dta

	**Life-span analysis
	estimates clear
	foreach name of local varlist_`sex'{
		
		*Set follow-up time and outcome
		
		if "`name'"!="pm_breast_cancer" & "`name'"!="cancer_detail_cat41" {
			stset dox, enter(fu_start1_58) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="pm_breast_cancer"{
			stset dox, enter(fu_start1_postmen_breast) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="cancer_detail_cat41"{
			stset dox, enter(fu_start1_93) failure(`name') origin(dob) scale(365.25)
		}
		
		*Cox regression
		stcox b1.traj_q_weight c.weight_intercept_5kg b3.education b1.birth_country ///
						  b2.marital_status b2.current_smoker c.mheight, strata(bcohort)
		
		*Save estimates
		estimates store `name'
	}
	
	*Estimation table for lifespan
	etable, est("`varlist_`sex''") varlabel /// 
	column(estimates) 													///
	cstat(_r_b, nformat(%3.2f)) 										/// 
	cstat(_r_ci, cidelimiter("-") sformat("(%s)") nformat(%3.2f)) 		/// 
	cstat(_r_p, nformat(%5.3f))    										///
	mstat(N_sub, nformat(%9.0fc) label("No. of participants")) 			/// 
	mstat(N_fail, nformat(%9.0fc) label("No. of events")) 				/// 
	title(Life span weight trajectories in quintiles and outcomes) 		///
	export(Results\lifespan_`sex'_potential_weight.xls, sheet(lifespan) modify)
	
	**Life span - per quintile step:
	estimates clear
	foreach name of local varlist_`sex'{
		
		if "`name'"!="pm_breast_cancer" & "`name'"!="cancer_detail_cat41" {
			stset dox, enter(fu_start1_58) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="pm_breast_cancer"{
			stset dox, enter(fu_start1_postmen_breast) failure(`name') origin(dob) scale(365.25)
		}
		
		if "`name'"=="cancer_detail_cat41"{
			stset dox, enter(fu_start1_93) failure(`name') origin(dob) scale(365.25)
		}
		
		stcox traj_q_weight c.weight_intercept_5kg b3.education b1.birth_country ///
						  b2.marital_status b2.current_smoker c.mheight, strata(bcohort)
		estimates store `name'
	}
	
	
	*Estimation table for lifespan, per quintile step:
	etable, est("`varlist_`sex''") varlabel /// 
	column(estimates) 														///
	cstat(_r_b, nformat(%3.2f)) 										/// 
	cstat(_r_ci, cidelimiter("-") sformat("(%s)") nformat(%3.2f)) 		/// 
	cstat(_r_p, nformat(%5.3f))    										///
	mstat(N_sub, nformat(%9.0fc) label("No. of participants")) 			/// 
	mstat(N_fail, nformat(%9.0fc) label("No. of events")) 				/// 
	title(Life span weight trajectories in quintiles and outcomes)		///
	export(Results\lifespan_`sex'_potential_weight.xls, sheet(lifespan_q) modify)

}

	
	
	
	
