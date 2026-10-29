*======================DESCRIPTIVE STATISTICS==================================*

*Author: Anton Nilsson
*Date: 2026-10-27
*Stata version: 19

*File 6

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

foreach sex in males females {
	
	local filename = "`sex'" + "3_lmm_bl.dta"
	
	use `filename', clear
	
	gen fu_end_with_cancer = 2-any_cancer
	label variable fu_end_with_cancer "Follow-up ending with cancer"
	label define any_lab 1 "Yes" 2 "No"
	label values fu_end_with_cancer any_lab
	
	*Table
	dtable, by(traj_q_weight, total) ///
	sample("Sample frequency (percent)", place(inlabels)) ///
	continuous(age_bl, statistics(median p25p75)) ///
	continuous(fu_years1, statistics(median p25p75)) ///
	factor(i.fu_end_with_cancer, statistics (fvfrequency fvpercent)) ///
	continuous(age_cancer, statistics(median p25p75)) ///
	factor(i.bcohort, statistics (fvfrequency fvpercent)) ///
	continuous(mheight, statistics(mean sd)) ///
	factor(i.edu, statistics (fvfrequency fvpercent)) ///
	factor(i.birth_country, statistics (fvfrequency fvpercent)) ///
	factor(i.marital_status, statistics (fvfrequency fvpercent)) ///
	factor(i.current_smoker, statistics (fvfrequency fvpercent)) ///
	define(p25p75 = p25 p75, delimiter(-)) ///
	nformat(%8.2f mean sd p25 p75) ///
	nformat(%8.0f median p25p75) ///
	sformat("(%s)" p25p75) ///
	title ("Table 1. Descriptive characteristics for `sex'") ///
	export(Results/Descriptives_`sex'.xlsx,sheet(baseline) modify)
	
	*Follow-up time:
	stset dox, enter(fu_start1_58) failure(any_cancer) origin(dob) scale(365.25) id(id)
	stptime, by(traj_q_weight)

	
}
