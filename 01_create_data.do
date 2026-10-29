*======CREATE MAIN DATAFILE FOR WEIGHT CHANGES - CANCER INCIDENCE PROJECT======*

*Author: Anton Nilsson
*Date: 2026-10-28
*Stata version: 19

*File 1

*Note: The data for this project is not publicly available but can be obtained 
*from the different cohorts and register holders after obtaining ethical permit. 
*Researchers with an ethical permit can also contact the PI of the ODDS project 
*Tanja Stocks to obtain the ODDS cohort. The cohort has been developed and 
*described by da Silva et al. (2024) and Sun (2024).

*==============================================================================*

*------------------------------------------------------------------------------*
**PREPARING DATA
*------------------------------------------------------------------------------*

*Set up
cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off

*Start from cohort base file
use "Original_data\cohort_basefile_updated.dta"

*Link to cancer data
merge m:1 id using "Original_data\cancer_column.dta"
drop if (_merge==2)
rename _merge merge_cancer

*Create year, month, and day of death
gen year_death = year(dat_death)
gen month_death = month(dat_death)
gen day_death = day(dat_death)
*Create year, month, and day of study 
gen month_study=month(date)
gen day_study=day(date)
gen year_study=year(date) 
*Create year, month, and day of emigration
gen month_emig=month(dat_emig)
gen day_emig=day(dat_emig)
gen year_emig=year(dat_emig)

*Study date
rename date dat_study

*Deal with problematic imputed dates
count if dat_death<dat_study & month_study==6 & day_study==15 & year_study==year_death
replace dat_study=dat_death-0.5 if dat_death<dat_study & month_study==6 & day_study==15 & year_study==year_death  

*Create date of exit
bysort id: gen dox = min(dat_emig, dat_death, dat_dia, date("31Dec2023", "DMY"))
format dox %td
label var dox "Date of exit"

*Time of follow-up
gen fu_years = (dox-dat_study)/365.25 if !missing(dox)
label var fu_years "Years of follow-up"

*------------------------------------------------------------------------------*		 
**Sample construction
*------------------------------------------------------------------------------*		 

*Drop those with changed id
drop if idchange==1

*Drop those with reused id 
drop if idreuse==1

*Drop those with missing data on education 
drop if education==.

*Drop those with missing data on marital status
drop if marital_status==.

*Drop those with missing or implausable values on height
drop if mheight==. | mheight<100 | mheight>230

*Drop those with implausable values on weight
drop if weight<30 | weight>200 

*Drop those with weight measured after age 60
drop if age>=61

*Drop those with prevalent cancer
drop if dat_dia1<=dat_study

*Drop those emigrated at study date
drop if dat_emig<=dat_study

*Drop those recorded as dead at study date
drop if dat_death<=dat_study

*Drop those with less than a year until cancer
drop if dat_dia1>dat_study & dat_dia1<=dat_study+365

*Drop those with less than a year until emigration
drop if dat_emig>dat_study & dat_emig<=dat_study+365

*Drop those with less than a year until death
drop if dat_death>dat_study & dat_death<=dat_study+365

*Drop cohorts making up less than 1 %
ta cohort, nolab
drop if cohort==4 | cohort==5 | cohort==8 | cohort==10 | cohort==13 | cohort==15

save after_exclusions.dta
