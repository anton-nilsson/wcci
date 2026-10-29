*====================================ANALYSIS==================================*

*The role of weight at age 17 
*Both established and potentially obesity-related cancers
*Results adjusted and unadjusted for subsequent weight trajectories

*Author: Anton Nilsson
*Date: 2026-10-28
*Stata version: 19

*File 9

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*==============================================================================*
*Results adjusted for subsequent weight trajectory
*==============================================================================*

**Established obesity-related cancers

*Established obesity-related cancers to analyze in males:
local varlist_males "any_cancer any_ob_est_cancer cancer_detail_cat11 cancer_detail_cat14 cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat12 cancer_middle_cat14 cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat52 "
*Established obesity-related cancers to analyze in females:
local varlist_females "any_cancer any_ob_est_cancer cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat14 pm_breast_cancer cancer_detail_cat41 cancer_middle_cat25  cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat38 cancer_middle_cat52 "

foreach sex in males females{
	use `sex'3_lmm_bl.dta, clear
	
	xtile weight17_q = weight_intercept, nq(5) 

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
		stcox b1.weight17_q b1.traj_q_weight b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_established_weight17_adj.xls, sheet(lifespan) modify)
	
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
		
		stcox b1.weight17_q b1.traj_q_weight b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_established_weight17_adj.xls, sheet(lifespan_q) modify)

}


**Potentially obesity-related cancers

*Potentially obesity-related cancers in males:
local varlist_males "any_ob_pot_cancer cancer_not_est_pot cancer_middle_cat1 cancer_middle_cat9 cancer_middle_cat18 cancer_middle_cat41 cancer_middle_cat48 cancer_detail_cat86 cancer_detail_cat87 cancer_detail_cat89 myeloid"
*Potentially obesity-related cancers in females:
local varlist_females "any_ob_pot_cancer cancer_not_est_pot cancer_morphology_cat7 cancer_detail_cat39 cancer_middle_cat40 cancer_middle_cat41 cancer_detail_cat86 myeloid"

foreach sex in males females{
	use `sex'3_lmm_bl.dta, clear

	xtile weight17_q = weight_intercept, nq(5) 
	
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
		stcox b1.weight17_q b1.traj_q_weight b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_potential_weight17_adj.xls, sheet(lifespan) modify)
	
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
		
		stcox b1.weight17_q b1.traj_q_weight b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_potential_weight17_adj.xls, sheet(lifespan_q) modify)

}

*==============================================================================*
*Results unadjusted for subsequent weight trajectory
*==============================================================================*

**Established obesity-related cancers

*Established obesity-related cancers to analyze in males:
local varlist_males "any_cancer any_ob_est_cancer cancer_detail_cat11 cancer_detail_cat14 cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat12 cancer_middle_cat14 cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat52 "
*Established obesity-related cancers to analyze in females:
local varlist_females "any_cancer any_ob_est_cancer cancer_middle_cat10 cancer_detail_cat21 cancer_middle_cat14 pm_breast_cancer cancer_detail_cat41 cancer_middle_cat25  cancer_middle_cat31 cancer_middle_cat33 cancer_middle_cat38 cancer_middle_cat52 "

foreach sex in males females{
	use `sex'3_lmm_bl.dta, clear
	
	xtile weight17_q = weight_intercept, nq(5) 

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
		stcox b1.weight17_q b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_established_weight17_unadj.xls, sheet(lifespan) modify)
	
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
		
		stcox b1.weight17_q b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_established_weight17_unadj.xls, sheet(lifespan_q) modify)

}


**Potentially obesity-related cancers

*Potentially obesity-related cancers in males:
local varlist_males "any_ob_pot_cancer cancer_not_est_pot cancer_middle_cat1 cancer_middle_cat9 cancer_middle_cat18 cancer_middle_cat41 cancer_middle_cat48 cancer_detail_cat86 cancer_detail_cat87 cancer_detail_cat89 myeloid"
*Potentially obesity-related cancers in females:
local varlist_females "any_ob_pot_cancer cancer_not_est_pot cancer_morphology_cat7 cancer_detail_cat39 cancer_middle_cat40 cancer_middle_cat41 cancer_detail_cat86 myeloid"

foreach sex in males females{
	use `sex'3_lmm_bl.dta, clear

	xtile weight17_q = weight_intercept, nq(5) 
	
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
		stcox b1.weight17_q b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_potential_weight17_unadj.xls, sheet(lifespan) modify)
	
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
		
		stcox b1.weight17_q b3.education b1.birth_country ///
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
	export(Results\lifespan_`sex'_potential_weight17_unadj.xls, sheet(lifespan_q) modify)

}

	

