* 02_analysis.do
* Summary stats, regressions, and data for R figures

clear all
set more off

global project "`c(pwd)'"
cd "$project"

use "data/processed/analysis_data.dta", clear

* Summary statistics

log using "outputs/tables/summary_stats.txt", text replace

count
sum annual_wage log_wage age
tab year
tab covid
tab remote_workable
tab covid remote_workable
tab race
tab age_group
tab sex
tab college

log close

* Make small files for the R figure script

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year)

export delimited using "data/processed/overall_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year remote_workable)

export delimited using "data/processed/remote_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year race)

export delimited using "data/processed/race_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year sex)

export delimited using "data/processed/gender_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year college)

export delimited using "data/processed/college_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year ind)

export delimited using "data/processed/industry_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year stateicp)

export delimited using "data/processed/state_trends_for_r.csv", replace nolabel

restore

preserve

collapse (p10) wage_p10=annual_wage (p50) wage_p50=annual_wage ///
    (p90) wage_p90=annual_wage, by(year)

gen p90_p10_gap = wage_p90 - wage_p10
gen p90_p10_ratio = wage_p90 / wage_p10

export delimited using "data/processed/inequality_trends_for_r.csv", replace nolabel

restore

preserve

collapse (mean) annual_wage log_wage [pw=perwt], by(year age_group)

export delimited using "data/processed/age_trends_for_r.csv", replace nolabel

restore

* Regressions

log using "outputs/tables/regressions.txt", text replace

* Main wage regression after COVID.
* The coefficient on 1.covid shows the average wage difference after 2020.

reg log_wage i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

* Remote work regression.
* Main coefficient to look at:
* 1.remote_workable#1.covid
*
* Since the outcome is log_wage, a coefficient of 0.05 is about 5 percent.

reg log_wage i.remote_workable##i.covid [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year [pw=perwt], robust

reg log_wage i.remote_workable##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year i.ind [pw=perwt], robust

reg log_wage c.remote_score##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.year i.ind [pw=perwt], robust

* Heterogeneity by race and age group.

reg log_wage i.race##i.covid age age2 i.educ i.sex ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.age_group##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.sex##i.covid age age2 i.educ i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.college##i.covid age age2 i.sex i.race ///
    i.stateicp i.ind [pw=perwt], robust

reg log_wage i.ind##i.covid age age2 i.educ i.sex i.race ///
    i.stateicp [pw=perwt], robust

reg log_wage i.stateicp##i.covid age age2 i.educ i.sex i.race ///
    i.ind [pw=perwt], robust

log close

* Figures in R

* This runs the R figure script.
* The full Rscript path is used because Stata may not know where R is on Mac.

shell "/usr/local/bin/Rscript" "code/03_figures.R" "$project"

di "Analysis complete."
