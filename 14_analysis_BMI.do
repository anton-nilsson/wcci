*==================================ANALYSIS====================================*

*Analysis of BMI

*Author: Anton Nilsson
*Date: 2026-10-28
*Stata version: 19

*File 14

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Outcomes to analyze:
local varlist "any_cancer any_ob_est_cancer any_ob_pot_cancer cancer_not_est_pot"

foreach sex in males females{
	use `sex'3_lmm_bl.dta
	
	**Life-span analysis
	estimates clear
	foreach name of local varlist{

		stset dox, enter(fu_start1_58) failure(`name') origin(dob) scale(365.25)
			
		*Cox regression
		stcox b1.traj_q_bmi c.bmi_intercept_5kg b3.education b1.birth_country ///
						  b2.marital_status b2.current_smoker c.mheight, strata(bcohort)
		
		*Save estimates
		estimates store `name'
	
	}
	
	*Estimation table
	etable, est("`varlist'") varlabel /// 
	column(estimates) 													///
	cstat(_r_b, nformat(%3.2f)) 										/// 
	cstat(_r_ci, cidelimiter("-") sformat("(%s)") nformat(%3.2f)) 		/// 
	cstat(_r_p, nformat(%5.3f))    										///
	mstat(N_sub, nformat(%9.0fc) label("No. of participants")) 			/// 
	mstat(N_fail, nformat(%9.0fc) label("No. of events")) 				/// 
	title(Life span bmi trajectories in quintiles and outcomes) 		///
	export(Results\BMI_`sex'.xls, sheet(lifespan) modify)
	
	**Life-span analysis - per Q
	estimates clear
	foreach name of local varlist{

		stset dox, enter(fu_start1_58) failure(`name') origin(dob) scale(365.25)
			
		*Cox regression
		stcox traj_q_bmi c.bmi_intercept_5kg b3.education b1.birth_country ///
						  b2.marital_status b2.current_smoker c.mheight, strata(bcohort)
		
		*Save estimates
		estimates store `name'
	
	}
	
	*Estimation table
	etable, est("`varlist'") varlabel /// 
	column(estimates) 													///
	cstat(_r_b, nformat(%3.2f)) 										/// 
	cstat(_r_ci, cidelimiter("-") sformat("(%s)") nformat(%3.2f)) 		/// 
	cstat(_r_p, nformat(%5.3f))    										///
	mstat(N_sub, nformat(%9.0fc) label("No. of participants")) 			/// 
	mstat(N_fail, nformat(%9.0fc) label("No. of events")) 				/// 
	title(Life span bmi trajectories in quintiles and outcomes) 		///
	export(Results\BMI_`sex'.xls, sheet(lifespan_q) modify)
	
}


	
	
	
	
	
	
	
