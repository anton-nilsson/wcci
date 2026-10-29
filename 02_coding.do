*=================CODING VARIABLES AND CONSTRUCTING ANALYTIC SAMPLES===========*

*Author: Anton Nilsson 
*Date: 2025-10-29
*Stata version: 19

*File 2

*==============================================================================*

cd \\micro.intra\projekt\P1161$\P1161_Gem\Anton\WCCI
clear
set more off
use after_exclusions.dta, clear

*Age at third measurement
bysort id (dat_study): gen third_age = age[3]
label variable third_age "Age at third measurement"

*Age at baseline
gen age_bl = third_age+1
label variable third_age "Age at baseline (one year after third measurement)"

*Age at cancer
gen age_cancer = (dat_dia1-dob)/365.25
label variable age_cancer "Age at cancer diagnosis"

*Label marital status
label define marital_status 1 "Unmarried" /// 
							2 "Married" ///
							3 "Divorced or widow/-er", modify

*Label education
replace education=5 if education>5 & !missing(education)
label define education 1 "Pre-upper secondary school <9 yrs" /// 
					   2 "Pre-upper secondary school 9 yrs" ///
					   3 "Upper secondary school <3 yrs" /// 
					   4 "Upper secondary school 3 yrs" ///
					   5 "Post-upper secondary school ≥1 yrs" ///
					   6 "" ///
					   7 "", modify					   
label variable education "Highest achieved education"

*Label birth country
replace birth_country=2 if birth_country==3
replace birth_country=3 if birth_country==4
label define birth_country 1 "Born in Swe with both parents born in Sweden" ///
						   2 "Born in Swe with one or both parents born abroad" ///
						   3 "Born abroad" ///
						   4 " ", modify

*Smoking
gen current_smoker =.
replace current_smoker=1 if ciginf == 3
replace current_smoker=2 if (ciginf == 1|ciginf == 2|ciginf == 4)
label variable current_smoker "Current smoker?"
*With category for missing:
replace current_smoker = 9 if current_smoker==.
label define smoklab 1 "Yes" 2 "No" 9 "Missing"
label values current_smoker smoklab
						   
*Cancer groups and labels:

*Exclude cancers occurring after endpoint
forvalues i=1(1)4{
	replace cancer_broad`i' = . if dat_dia1>dox & dat_dia1!=.
	replace cancer_middle`i' = . if dat_dia1>dox & dat_dia1!=.
	replace cancer_detail`i' = . if dat_dia1>dox & dat_dia1!=.
	replace morphology`i' = . if dat_dia1>dox & dat_dia1!=.
}

*Indicator for any cancer
gen any_cancer = cancer_broad1!=.

*Broad groups
forvalues i=1(1)13{
	gen cancer_broad_cat`i' = cancer_broad1 ==`i' | cancer_broad2 ==`i' | cancer_broad3 ==`i' | cancer_broad4 ==`i' 
}
label variable cancer_broad_cat1 "head and neck"
label variable cancer_broad_cat2 "GI tract"
label variable cancer_broad_cat3 "respiratory tract"
label variable cancer_broad_cat4 "skin"
label variable cancer_broad_cat5 "breast"
label variable cancer_broad_cat6 "female gen organs"
label variable cancer_broad_cat7 "male gen organs"
label variable cancer_broad_cat8 "urinary tract"
label variable cancer_broad_cat9 "brain/CNS"
label variable cancer_broad_cat10 "endocrine organs"
label variable cancer_broad_cat11 "other solid cancers"
label variable cancer_broad_cat12 "lymph/hematopoietic"
label variable cancer_broad_cat13 "other/UNS cancer"

*Middle-level groups
forvalues i=1(1)57{
	gen cancer_middle_cat`i' = cancer_middle1 ==`i' | cancer_middle2 ==`i' | cancer_middle3 ==`i' | cancer_middle4 ==`i'
}
label variable cancer_middle_cat1 "oral cavity"   
label variable cancer_middle_cat2 "salivary glands"
label variable cancer_middle_cat3 "pharynx"
label variable cancer_middle_cat4 "(para)nasal sinuses"
label variable cancer_middle_cat5 "larynx"   
label variable cancer_middle_cat6 "head/neck-other/UNS"
label variable cancer_middle_cat7 "oesophagus"
label variable cancer_middle_cat8 "gastric"
label variable cancer_middle_cat9 "small intestine"
label variable cancer_middle_cat10 "colon"
label variable cancer_middle_cat11 "rectum/anus"
label variable cancer_middle_cat12 "liver"
label variable cancer_middle_cat13 "biliary tract"
label variable cancer_middle_cat14 "pancreas"
label variable cancer_middle_cat15 "GI-other/UNS"
label variable cancer_middle_cat16 "trachea"
label variable cancer_middle_cat17 "lung/bronchus"
label variable cancer_middle_cat18 "melanoma skin"
label variable cancer_middle_cat19 "non-melanoma skin"
label variable cancer_middle_cat20 "breast"
label variable cancer_middle_cat21 "vulva"
label variable cancer_middle_cat22 "vagina"
label variable cancer_middle_cat23 "cervix"
label variable cancer_middle_cat24 "uterus"
label variable cancer_middle_cat25 "ovary"
label variable cancer_middle_cat26 "female gen-other/UNS"
label variable cancer_middle_cat27 "penis"
label variable cancer_middle_cat28 "prostate"
label variable cancer_middle_cat29 "testis"
label variable cancer_middle_cat30 "male gen-other/UNS"
label variable cancer_middle_cat31 "kidney"
label variable cancer_middle_cat32 "urinary tract-other"
label variable cancer_middle_cat33 "brain/CNS-meningioma"
label variable cancer_middle_cat34 "brain/CNS-low grade glioma"
label variable cancer_middle_cat35 "brain/CNS-high grade glioma"
label variable cancer_middle_cat36 "brain/CNS-other/UNS"
label variable cancer_middle_cat37 "pancreatic islets"
label variable cancer_middle_cat38 "thyroid"
label variable cancer_middle_cat39 "adrenal glands"
label variable cancer_middle_cat40 "parathyroid gland"
label variable cancer_middle_cat41 "pituitary gland"
label variable cancer_middle_cat42 "endocrine-other/UNS"
label variable cancer_middle_cat43 "thymys"
label variable cancer_middle_cat44 "mediastinum"
label variable cancer_middle_cat45 "pleura"
label variable cancer_middle_cat46 "bone/articular cartilage"
label variable cancer_middle_cat47 "(retri)peritoneum"
label variable cancer_middle_cat48 "connective tissue"
label variable cancer_middle_cat49 "eye"
label variable cancer_middle_cat52 "multiple myeloma"
label variable cancer_middle_cat53 "acute lymphocytic leukaemia"
label variable cancer_middle_cat54 "lymph/hemato-other/UNS"
label variable cancer_middle_cat55 "other/UNS cancer"
label variable cancer_middle_cat56 "myeloid"
label variable cancer_middle_cat57 "lymphoid"

*Detailed groups
forvalues i=1(1)103{
	gen cancer_detail_cat`i' = cancer_detail1 ==`i' | cancer_detail2 ==`i' | cancer_detail3 ==`i'  | cancer_detail4 ==`i'
}
label variable cancer_detail_cat1 "lip"
label variable cancer_detail_cat2 "tounge"
label variable cancer_detail_cat3 "mouth"
label variable cancer_detail_cat4 "salivary glands"
label variable cancer_detail_cat5 "oropharynx"
label variable cancer_detail_cat6 "nasopharynx"
label variable cancer_detail_cat7 "hypopharynx"
label variable cancer_detail_cat8 "(para)nasal sinuses"
label variable cancer_detail_cat9 "larynx"
label variable cancer_detail_cat10 "head/neck-other/UNS"
label variable cancer_detail_cat11 "oeso-adenocarcinoma"
label variable cancer_detail_cat12 "oeso-SCC"
label variable cancer_detail_cat13 "oeso-other/UNS"
label variable cancer_detail_cat14 "gastric-cardia"
label variable cancer_detail_cat15 "gastric-noncardia"
label variable cancer_detail_cat16 "gastric-other/UNS"
label variable cancer_detail_cat17 "small intestine"
label variable cancer_detail_cat18 "colon-proximal"
label variable cancer_detail_cat19 "colon-distal"
label variable cancer_detail_cat20 "colon-other/UNS"
label variable cancer_detail_cat21 "rectum"
label variable cancer_detail_cat22 "anus"
label variable cancer_detail_cat23 "liver"
label variable cancer_detail_cat24 "biliary tract-other/UNS"
label variable cancer_detail_cat25 "pancreas"
label variable cancer_detail_cat26 "GI-other/UNS"
label variable cancer_detail_cat27 "trachea"
label variable cancer_detail_cat28 "lung-adenocarcinoma"
label variable cancer_detail_cat29 "lung-SCC"
label variable cancer_detail_cat30 "lung-small cell"
label variable cancer_detail_cat31 "lung-large cell"
label variable cancer_detail_cat32 "lung-other/UNS"
label variable cancer_detail_cat33 "melanoma skin"
label variable cancer_detail_cat34 "non-melanoma skin"
label variable cancer_detail_cat35 "breast"
label variable cancer_detail_cat36 "vulva"
label variable cancer_detail_cat37 "vagina"
label variable cancer_detail_cat38 "cervix-SCC"
label variable cancer_detail_cat39 "cervix-adenocarcinoma"
label variable cancer_detail_cat40 "cervix-other/UNS"
label variable cancer_detail_cat41 "endometrium"
label variable cancer_detail_cat42 "corpus uteri-other/UNS"
label variable cancer_detail_cat43 "uterus-other"
label variable cancer_detail_cat44 "ovary-serous"
label variable cancer_detail_cat45 "ovary-mucinous"
label variable cancer_detail_cat46 "ovary-endometrioid"
label variable cancer_detail_cat47 "ovary-clear cell"
label variable cancer_detail_cat48 "ovary-other/UNS"
label variable cancer_detail_cat49 "female gen-other/UNS"
label variable cancer_detail_cat50 "penis"
label variable cancer_detail_cat51 "prostate"
label variable cancer_detail_cat52 "testis"
label variable cancer_detail_cat53 "male gen-other/UNS"
label variable cancer_detail_cat54 "RCC-clear cell"
label variable cancer_detail_cat55 "RCC-papillary"
label variable cancer_detail_cat56 "RCC-chromophobe"
label variable cancer_detail_cat57 "RCC-other/UNS"
label variable cancer_detail_cat58 "kidney-UNS"
label variable cancer_detail_cat59 "pelvis"
label variable cancer_detail_cat60 "ureter"
label variable cancer_detail_cat61 "bladder"
label variable cancer_detail_cat62 "other urin tract-other/UNS"
label variable cancer_detail_cat63 "brain-meningioma"
label variable cancer_detail_cat64 "brain/CNS-low grade glioma"
label variable cancer_detail_cat65 "brain/CNS-high grade glioma"
label variable cancer_detail_cat66 "brain/CNS-other/UNS"
label variable cancer_detail_cat67 "pancreatic islets"
label variable cancer_detail_cat68 "thyroid-papillary"
label variable cancer_detail_cat69 "thyroid-follicular"
label variable cancer_detail_cat70 "thyroid-other/UNS"
label variable cancer_detail_cat71 "adrenal glands"
label variable cancer_detail_cat72 "parathyroid gland"
label variable cancer_detail_cat73 "pituitary gland"
label variable cancer_detail_cat74 "endocrine-other/UNS"
label variable cancer_detail_cat75 "thymys"
label variable cancer_detail_cat76 "mediastinum"
label variable cancer_detail_cat77 "pleura"
label variable cancer_detail_cat78 "bone/articular cartilage"
label variable cancer_detail_cat79 "(retri)peritoneum"
label variable cancer_detail_cat80 "connective tissue"
label variable cancer_detail_cat81 "eye"
label variable cancer_detail_cat82 "hodkin-nodular sclerosis"
label variable cancer_detail_cat83 "hodkin-mixed cellularity"
label variable cancer_detail_cat84 "hodkin-nodular lymphocyte"
label variable cancer_detail_cat85 "hodkin-other/UNS"
label variable cancer_detail_cat86 "nonhodkin-diff large B-cell"
label variable cancer_detail_cat87 "nonhodkin-follicular"
label variable cancer_detail_cat88 "nonhodkin-Tcell/NKcell"
label variable cancer_detail_cat89 "nonhodkin-chr lymph leuk"
label variable cancer_detail_cat90 "nonhodkin-other/UNS"
label variable cancer_detail_cat91 "multiple myeloma"
label variable cancer_detail_cat92 "leukemia-acute lymph"
label variable cancer_detail_cat93 "leukemia-acute myeloid"
label variable cancer_detail_cat94 "leukemia-chronic myeloid"
label variable cancer_detail_cat95 "leukemia-other/UNS"
label variable cancer_detail_cat96 "lymph/hemato-other/UNS"
label variable cancer_detail_cat97 "other/UNS cancer"
label variable cancer_detail_cat98 "duodenum"
label variable cancer_detail_cat99 "jejunum"
label variable cancer_detail_cat100 "ileum"
label variable cancer_detail_cat101 "gallbladder"
label variable cancer_detail_cat102 "extrahepatic bile ducts"
label variable cancer_detail_cat103 "ampulla/papilla of vater"

*Morphology
forvalues i=1(1)23{
	gen cancer_morphology_cat`i' = morphology1 ==`i' | morphology2 ==`i' | morphology3 ==`i' | morphology4 ==`i'
}
label variable cancer_morphology_cat1 "other urinary tract uc"
label variable cancer_morphology_cat2 "other urinary tract ad"
label variable cancer_morphology_cat3 "other urinary tract scc"
label variable cancer_morphology_cat4 "head neck acc"
label variable cancer_morphology_cat5 "head neck mc" 
label variable cancer_morphology_cat6 "head neck ad" 
label variable cancer_morphology_cat7 "head neck scc"
label variable cancer_morphology_cat8 "small intestine ad"
label variable cancer_morphology_cat9 "small intestine neuro" 
label variable cancer_morphology_cat10 "small intestine gist"   
label variable cancer_morphology_cat11 "endometrial type I"
label variable cancer_morphology_cat12 "endometrial type II"
label variable cancer_morphology_cat13 "melanoma acral"
label variable cancer_morphology_cat14 "melanoma LMM"
label variable cancer_morphology_cat15 "melanoma NM"
label variable cancer_morphology_cat16 "melanoma SSM"
label variable cancer_morphology_cat17 "colon ad"
label variable cancer_morphology_cat18 "colon neuro"
label variable cancer_morphology_cat19 "rectum anus ad"
label variable cancer_morphology_cat20 "rectum anus neuro"
label variable cancer_morphology_cat21 "gastric ad"
label variable cancer_morphology_cat22 "gastric neuro"
label variable cancer_morphology_cat23 "gastric gist"

*Postmenopausal breast cancer
gen pm_breast_cancer = cancer_detail_cat35==1 & age_cancer>=55

*Any established obesity-related cancer?
gen any_ob_est_cancer = cancer_detail_cat11==1 | cancer_detail_cat14==1 | cancer_middle_cat10 == 1 | cancer_detail_cat21 == 1 | cancer_middle_cat12==1 | cancer_detail_cat101 == 1 | cancer_middle_cat14 == 1 | pm_breast_cancer == 1 | cancer_detail_cat41 == 1 | cancer_middle_cat25 == 1 | cancer_middle_cat33 == 1 | cancer_middle_cat38 == 1 | cancer_middle_cat52 == 1 | cancer_middle_cat31 == 1

*Any established obesity-related cancer without "female cancers" (breast, ovarian, endometrial)
gen any_ob_est_cancer_no_fem = cancer_detail_cat11==1 | cancer_detail_cat14==1 | cancer_middle_cat10 == 1 | cancer_detail_cat21 == 1 | cancer_middle_cat12==1 | cancer_detail_cat101 == 1 | cancer_middle_cat14 == 1 | cancer_middle_cat33 == 1 | cancer_middle_cat38 == 1 | cancer_middle_cat52 == 1 | cancer_middle_cat31 == 1 

*Potentially cancer-related:

*Biliary tract excluding gallbladder
gen bill_cancer_excl_gb = cancer_middle_cat13 == 1 & cancer_detail_cat101 == 0
*Lymphoid
gen lymphoid = cancer_detail_cat82 == 1 | cancer_detail_cat83 == 1 | cancer_detail_cat84 == 1 | cancer_detail_cat85 == 1 | cancer_detail_cat86 == 1 | cancer_detail_cat87 == 1 | cancer_detail_cat88 == 1 | cancer_detail_cat89 == 1 | cancer_detail_cat90 == 1 | cancer_detail_cat92 == 1
*Myeloid
gen myeloid = cancer_detail_cat93 == 1 | cancer_detail_cat94 == 1 | cancer_detail_cat95 == 1

*Any potentially obesity-related
gen any_ob_pot_cancer = (sex==1 & (cancer_middle_cat1==1 | cancer_middle_cat4==1 | cancer_morphology_cat6==1 | cancer_morphology_cat23==1 | cancer_middle_cat9==1 | bill_cancer_excl_gb==1 | cancer_middle_cat18==1 | cancer_middle_cat27==1 | cancer_middle_cat37==1 | cancer_middle_cat39==1 | cancer_middle_cat40==1 | cancer_middle_cat41==1 | cancer_middle_cat48==1 | lymphoid==1 | myeloid==1)) | (sex==2 & (cancer_middle_cat1==1 | cancer_middle_cat4==1 | cancer_morphology_cat23==1 | cancer_middle_cat9==1 | bill_cancer_excl_gb==1 | cancer_middle_cat37==1 | cancer_middle_cat39==1 | cancer_middle_cat40==1 | cancer_middle_cat41==1 | cancer_middle_cat48==1 | lymphoid==1 | myeloid==1 | cancer_morphology_cat7==1 | cancer_morphology_cat15==1 | cancer_middle_cat21==1 | cancer_detail_cat39==1))
	
*Cancer that is neither established nor potentially obesity-related
gen cancer_not_est_pot = any_cancer==1 & any_ob_est_cancer==0 & any_ob_pot_cancer==0

*Hodgkins
gen hodgkins = cancer_detail_cat82 == 1 | cancer_detail_cat83 == 1 | cancer_detail_cat84 == 1 | cancer_detail_cat85 == 1 

*BMI
gen bmi=(weight/((mheight/100)^2))
label variable bmi "bmi(kg/m2)"

*Weight at first record
bysort id (dat_study): gen first_weight=weight[1]
label variable first_weight "Weight at first measurement"

*Weight at third record
bysort id (dat_study): gen third_weight=weight[2]
label variable third_weight "Weight at third measurement"

**Year of birth
gen yob=year(dob)
label var yob "Year of birth"

**Birth cohort
gen bcohort=.
replace bcohort=1 if yob<1940
replace bcohort=2 if (yob>=1940 & yob<1950)
replace bcohort=3 if (yob>=1950 & yob<1960)
replace bcohort=4 if (yob>=1960 & yob<1970)
replace bcohort=5 if (yob>=1970 & yob<1980)
replace bcohort=6 if (yob>=1980)

label def bcohortlbl_new 1 "<1940" ///
                     2 "1940-1950" ///
					 3 "1950-1960" ///
					 4 "1960-1970" ///
					 5 "1970-1980" ///
					 6 ">=1980"
					 
label var bcohort "Birth cohort"
label values bcohort bcohortlbl_new
tab bcohort sex,m col

save after_exclusions2

*Main sample for males: at least 3 weight measurements
use after_exclusions2, clear
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=3 & sex==1
save males3.dta

*Main sample for females: at least 3 weight measurements
use after_exclusions2, clear
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=3 & sex==2
save females3.dta

*Secondary sample for males: at least 2 weight measurements
use after_exclusions2, clear
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=2 & sex==1
save males2.dta

*Secondary sample for females: at least 2 weight measurements
use after_exclusions2, clear
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=2 & sex==2
save females2.dta

*Sample with only objective weight measurements for males: at least 3 weight measurements
use after_exclusions2, clear
keep if weightm==1
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=3 & sex==1
save males3_objective_only.dta

*Sample with only objective weight measurements for females: at least 3 weight measurements
use after_exclusions2, clear
keep if weightm==1
bysort id: gen freq = _N
label variable freq "Number of weight measurements"
keep if freq>=3 & sex==2
save females3_objective_only.dta

