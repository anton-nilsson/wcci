# Weight trajectories and cancer risk: a pooled cohort study

The repository contains Stata scipts for _Weight Trajectories and Cancer Risk: A Pooled Cohort Study_ (Nilsson et al.). 
The study is based on Swedish register data which cannot be publicly shared. The scripts therefore aim to show the analytical workflow rather than allow for immediate reproduction of the study.
Access to data requires ethical approval from the Swedish Ethical Review Board and is subject to requests to Statistics Sweden, the Swedish National Board of Health and Welfare, the Swedish Defence Conscription and Assessment Agency and the National Military Archive, Umeå University, Lund University, Karolinska Institutet, and Uppsala University. Researchers with an ethical permit may also contact PI Tanja Stocks for access to the compiled dataset.

## Description of scripts

- `01_create_data.do` prepares data and applies exclusion criteria
- `02_coding.do` creates and labels basic variables, and generates the specific study populations
- `03_LMM.do` applies Linear Mixed Models to generate weight trajectories
- `04_predicted.do` predicts weight trajectories across the lifespan
- `05_individual.do` creates analytic files with follow-up from baseline
- `06_descriptives.do` generates descriptive statistics
- `07_analysis_established.do` conducts the main analysis for established obesity-related cancers
- `08_analysis_potential.do` conducts the analysis for potentially obesity-related cancers
- `09_analysis_age17` conducts the analysis for the role of weight at age 17
- `10_analysis_obesity_onset` conducts the analysis for the role of the age of obesity onset
- `11_analysis_smoke.do` conducts the sensitivity analysis with and without smoking adjustment
- `12_analysis_noloss.do` conducts the sensitivity analysis excluding individuals losing weight
- `13_analysis_2obs.do` conducts the sensitivity analysis for individuals with at least two weight measurements
- `14_analysis_BMI.do` conducts the sensitivity analysis for BMI instead of weight
- `15_analysis_obj_only.do` conducts the sensitivity analysis based only on objective weight measurements

## Contact

For any questions about the code, contact corresponding author Anton Nilsson (anton.nilsson@med.lu.se). 
