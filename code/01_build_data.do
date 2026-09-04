* 01_build_data.do
* Clean ACS, clean remote work data, and merge everything together

clear all
set more off

global project "`c(pwd)'"
cd "$project"

* Clean ACS/IPUMS data

use "data/raw/usa_00001.dta", clear

capture rename *, lower

keep if empstat == 1
keep if !missing(age) & age >= 25 & age <= 54

keep if !missing(incwage) & incwage > 0

gen soc = trim(occsoc)
drop if soc == "" | soc == "0" | soc == "000000"
drop if strpos(soc, "X") > 0

gen annual_wage = incwage

* CPI-U annual averages. Wages are converted into 2024 dollars.
* Formula: real wage = nominal wage * CPI in 2024 / CPI in that year.
gen cpi = .
replace cpi = 240.007 if year == 2016
replace cpi = 245.120 if year == 2017
replace cpi = 251.107 if year == 2018
replace cpi = 255.657 if year == 2019
replace cpi = 258.811 if year == 2020
replace cpi = 270.970 if year == 2021
replace cpi = 292.655 if year == 2022
replace cpi = 304.702 if year == 2023
replace cpi = 313.689 if year == 2024

drop if missing(cpi)

gen real_annual_wage = annual_wage * (313.689 / cpi)

sum real_annual_wage
local mean = r(mean)
local sd = r(sd)
drop if real_annual_wage > `mean' + (2 * `sd')
drop if real_annual_wage < `mean' - (2 * `sd')

gen covid = year > 2020
gen log_nominal_wage = log(annual_wage)
gen log_real_wage = log(real_annual_wage)
gen log_wage = log_real_wage
gen age2 = age^2
gen college = educ >= 10

label define college_label 0 "No college degree" 1 "College degree"
label values college college_label

gen age_group = .
replace age_group = 1 if age >= 25 & age <= 34
replace age_group = 2 if age >= 35 & age <= 44
replace age_group = 3 if age >= 45 & age <= 54

label define age_group_label 1 "25-34" 2 "35-44" 3 "45-54"
label values age_group age_group_label

count
sum annual_wage real_annual_wage log_real_wage age
tab year
tab covid

save "data/processed/cleaned.dta", replace

* Clean Dingel and Neiman remote work data

import delimited "data/raw/remote/occupations_workathome.csv", clear varnames(1)

rename onetsoccode soc
rename teleworkable remote_workable

replace soc = subinstr(soc, "-", "", .)
replace soc = subinstr(soc, ".", "", .)
replace soc = substr(soc, 1, 6)

keep soc remote_workable
drop if missing(soc)
drop if missing(remote_workable)
collapse (mean) remote_score=remote_workable, by(soc)
gen remote_workable = remote_score >= .5

save "data/processed/remote_soc_only.dta", replace

* Merge ACS with remote work data

use "data/processed/cleaned.dta", clear

merge m:1 soc using "data/processed/remote_soc_only.dta"
tab _merge

keep if _merge == 3
drop _merge

save "data/processed/analysis_data.dta", replace

di "Saved final data to data/processed/analysis_data.dta"
