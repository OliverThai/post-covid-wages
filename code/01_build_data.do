* Broad earnings sample: no occupation match and no arbitrary earnings deletion.
version 16
clear all
set more off
set varabbrev off
capture mkdir "outputs/logs"
capture log close
log using "outputs/logs/build_data.log", text replace

use year sample serial pernum age sex race educ educd empstat stateicp ///
    perwt incwage uhrswork wkswork1 using "data/raw/usa_00001.dta", clear
capture rename *, lower
assert inlist(year,2016,2017,2018,2019,2021,2022,2023,2024)
assert sample == year*100 + 1
quietly levelsof year, local(years)
local nyears : word count `years'
assert `nyears' == 8
display "Stata version: " c(stata_version)

tempname audit
postfile `audit' str40 stage int year double observations double population using ///
    "data/processed/sample_flow.dta", replace
capture program drop record_sample
program define record_sample
    args handle stage
    foreach y in 2016 2017 2018 2019 2021 2022 2023 2024 {
        quietly count if year == `y'
        local n = r(N)
        quietly summarize perwt if year == `y', meanonly
        post `handle' ("`stage'") (`y') (`n') (r(sum))
    }
end
record_sample `audit' raw
keep if inrange(age,25,54)
record_sample `audit' ages_25_54
keep if perwt > 0 & !missing(perwt)
keep if inlist(sex,1,2) & inrange(educ,0,11) & inrange(educd,2,116)
keep if !missing(stateicp) & stateicp != 0 & stateicp != 83
record_sample `audit' valid_weight_demographics
isid sample serial pernum

gen byte employed = empstat == 1
gen byte valid_income = !missing(incwage) & !inlist(incwage,999998,999999)
gen byte positive_income = valid_income & incwage > 0
gen byte college = inlist(educd,101,114,115,116)
gen byte age_group = floor((age-25)/10) + 1
gen byte race_group = 4
replace race_group = 1 if race == 1
replace race_group = 2 if race == 2
replace race_group = 3 if inlist(race,4,5,6)
gen byte age_college = (age_group-1)*2 + college + 1

* Selection diagnostics include people excluded from positive-earner models.
preserve
collapse (mean) employed positive_income valid_income [pw=perwt], ///
    by(year age_group sex college)
export delimited using "outputs/tables/employment_and_income_coverage.csv", replace
restore
keep if positive_income
record_sample `audit' positive_valid_wage_income

gen double cpi = .
replace cpi = 240.007 if year == 2016
replace cpi = 245.120 if year == 2017
replace cpi = 251.107 if year == 2018
replace cpi = 255.657 if year == 2019
replace cpi = 270.970 if year == 2021
replace cpi = 292.655 if year == 2022
replace cpi = 304.702 if year == 2023
replace cpi = 313.689 if year == 2024
assert !missing(cpi)
gen double real_annual_wage = incwage * 313.689 / cpi
gen double log_real_wage = log(real_annual_wage)

* Fixed pre-period upper cap is a sensitivity check, not the main sample.
quietly _pctile real_annual_wage [aw=perwt] if year <= 2019 & employed, p(99)
scalar cap99 = r(r1)
gen double log_capped = log(min(real_annual_wage,scalar(cap99)))
display "Pre-period weighted P99 cap in 2024 dollars: " scalar(cap99)

* Optional rolling-income adjustment; it is not an exact timing correction.
gen double adjust = .
replace adjust = 1.007588 if year == 2016
replace adjust = 1.011189 if year == 2017
replace adjust = 1.013097 if year == 2018
replace adjust = 1.010145 if year == 2019
replace adjust = 1.029928 if year == 2021
replace adjust = 1.042311 if year == 2022
replace adjust = 1.019518 if year == 2023
replace adjust = 1.015250 if year == 2024
gen double log_adjusted = log_real_wage + log(adjust)

preserve
keep if employed
record_sample `audit' main_employed_positive_earners
tempname quant
postfile `quant' int year double p10 double p50 double p90 using ///
    "data/processed/weighted_quantiles.dta", replace
foreach y in 2016 2017 2018 2019 2021 2022 2023 2024 {
    quietly _pctile real_annual_wage [aw=perwt] if year == `y', p(10 50 90)
    post `quant' (`y') (r(r1)) (r(r2)) (r(r3))
}
postclose `quant'
restore
postclose `audit'

* Sufficient statistics retain survey-weighted sums, not averages of averages.
gen double weight = perwt
gen double weighted_log = perwt * log_real_wage
gen double weighted_real = perwt * real_annual_wage
gen double weighted_nominal = perwt * incwage
gen double weighted_capped = perwt * log_capped
gen double weighted_adjusted = perwt * log_adjusted
gen long n = 1
collapse (sum) weight weighted_log weighted_real weighted_nominal ///
    weighted_capped weighted_adjusted n, ///
    by(year stateicp age sex college age_group age_college race_group employed)
isid year stateicp age sex college race_group employed
assert weight > 0 & n > 0
save "data/processed/earnings_cells.dta", replace

use "data/processed/sample_flow.dta", clear
export delimited using "outputs/tables/sample_flow.csv", replace
use "data/processed/weighted_quantiles.dta", clear
gen p90_p10_ratio = p90/p10
export delimited using "outputs/tables/weighted_quantiles.csv", replace
log close
