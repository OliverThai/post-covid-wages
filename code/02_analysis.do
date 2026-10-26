* Growth rates and departures from pre-2020 trends, not a causal COVID effect.
version 16
clear all
set more off
set varabbrev off
capture log close
log using "outputs/logs/analysis.log", text replace
capture erase "outputs/tables/ANALYSIS_COMPLETE.txt"

tempname results paths support contrasts events pretests
postfile `results' str20 scenario str15 family int group str25 metric ///
    double estimate double se double lower double upper double p double df ///
    using "data/processed/trend_results.dta", replace
postfile `paths' str20 scenario str15 family int group year ///
    double observed double fitted double projected double real_mean double nominal_mean using ///
    "data/processed/trend_paths.dta", replace
postfile `support' str20 scenario int year double total_weight double retained_weight ///
    double total_n double retained_n using "data/processed/common_support.dta", replace
postfile `contrasts' str15 family int group reference str25 metric ///
    double estimate double se double lower double upper double p ///
    using "data/processed/relative_changes.dta", replace
postfile `events' str15 family int group reference year ///
    double estimate double se double lower double upper using "data/processed/event_gaps.dta", replace
postfile `pretests' str15 family int group reference double p using ///
    "data/processed/pretrend_tests.dta", replace

foreach scenario in main raw_mix cap99 income_timing all_earners race_fixed omit2021 late_baseline {
    use "data/processed/earnings_cells.dta", clear
    if "`scenario'" != "all_earners" keep if employed
    local cellvars stateicp age sex college age_group age_college
    if "`scenario'" == "race_fixed" local cellvars `cellvars' race_group
    collapse (sum) weight weighted_log weighted_real weighted_nominal ///
        weighted_capped weighted_adjusted n, by(year `cellvars')
    egen long cell = group(`cellvars')
    bysort cell: gen byte complete = _N == 8
    bysort cell: egen double baseline_weight = max(cond(year==2019,weight,.))
    foreach yr in 2016 2017 2018 2019 2021 2022 2023 2024 {
        quietly summarize weight if year==`yr', meanonly
        local w = r(sum)
        quietly summarize n if year==`yr', meanonly
        local n = r(sum)
        quietly summarize weight if year==`yr' & complete, meanonly
        local retained_w = r(sum)
        quietly summarize n if year==`yr' & complete, meanonly
        post `support' ("`scenario'") (`yr') (`w') (`retained_w') (`n') (r(sum))
    }
    * Fixed 2019 demographic composition; require observed cells in all years.
    if "`scenario'" != "raw_mix" keep if complete
    if "`scenario'" == "raw_mix" replace baseline_weight = weight
    assert baseline_weight > 0 & !missing(baseline_weight)
    gen double cell_log = weighted_log/weight
    if "`scenario'" == "cap99" replace cell_log = weighted_capped/weight
    if "`scenario'" == "income_timing" replace cell_log = weighted_adjusted/weight
    gen double num_log = cell_log*baseline_weight
    gen double num_real = weighted_real/weight*baseline_weight
    gen double num_nominal = weighted_nominal/weight*baseline_weight
    tempfile cells
    save `cells'

    foreach family in overall age sex college age_college {
        use `cells', clear
        gen byte group = 1
        if "`family'" == "age" replace group = age_group
        if "`family'" == "sex" replace group = sex
        if "`family'" == "college" replace group = college + 1
        if "`family'" == "age_college" replace group = age_college
        collapse (sum) num_log num_real num_nominal base_weight=baseline_weight, ///
            by(year stateicp group)
        gen double y = num_log/base_weight
        gen double real_mean = num_real/base_weight
        gen double nominal_mean = num_nominal/base_weight
        isid year stateicp group
        gen t = year-2019
        gen byte post = year >= 2021
        gen ramp = (year-2021)*post
        if "`scenario'" == "omit2021" drop if year==2021
        if "`scenario'" == "late_baseline" drop if year==2016
        tempfile panel
        save `panel'
        levelsof group, local(groups)

        foreach g of local groups {
            use `panel', clear
            keep if group==`g'
            quietly areg y c.t i.post c.ramp [aw=base_weight], ///
                absorb(stateicp) vce(cluster stateicp)
            assert e(N_clust) >= 30
            local df = e(df_r)
            foreach metric in pre_slope post_slope slope_change gap2021 gap2024 {
                local expression t
                if "`metric'" == "post_slope" local expression t + ramp
                if "`metric'" == "slope_change" local expression ramp
                if "`metric'" == "gap2021" local expression 1.post
                if "`metric'" == "gap2024" local expression 1.post + 3*ramp
                quietly lincom `expression'
                post `results' ("`scenario'") ("`family'") (`g') ("`metric'") ///
                    (r(estimate)) (r(se)) (r(lb)) (r(ub)) (r(p)) (`df')
            }
            predict double fitted, xbd
            gen double projected = fitted - _b[1.post]*post - _b[ramp]*ramp
            preserve
            collapse (mean) y fitted projected real_mean nominal_mean [aw=base_weight], by(year)
            forvalues i=1/`=_N' {
                post `paths' ("`scenario'") ("`family'") (`g') (year[`i']) ///
                    (y[`i']) (fitted[`i']) (projected[`i']) ///
                    (real_mean[`i']) (nominal_mean[`i'])
            }
            restore
            * Backtest: forecast 2019 using 2016-2018 only.
            if "`scenario'" == "main" {
                gen byte holdout = year==2019
                quietly areg y c.t i.holdout [aw=base_weight] if year<=2019, ///
                    absorb(stateicp) vce(cluster stateicp)
                local df = e(df_r)
                quietly lincom 1.holdout
                post `results' ("main") ("`family'") (`g') ("holdout2019_error") ///
                    (r(estimate)) (r(se)) (r(lb)) (r(ub)) (r(p)) (`df')
            }
        }

        * Compare slope changes between groups after absorbing state-year shocks.
        if "`scenario'" == "main" & "`family'" != "overall" {
            use `panel', clear
            egen long sy = group(stateicp year)
            egen long sg = group(stateicp group)
            local ref = 1
            if "`family'" == "age" local ref = 3
            if "`family'" == "age_college" local ref = 6
            quietly areg y i.sg ib`ref'.group##c.t ///
                ib`ref'.group##i.post ib`ref'.group##c.ramp ///
                [aw=base_weight], absorb(sy) vce(cluster stateicp)
            foreach g of local groups {
                if `g' != `ref' {
                    foreach metric in relative_pre_slope relative_slope_change relative_gap2024 {
                        local expression `g'.group#c.t
                        if "`metric'" == "relative_slope_change" local expression `g'.group#c.ramp
                        if "`metric'" == "relative_gap2024" local expression ///
                            `g'.group#1.post + 3*`g'.group#c.ramp
                        quietly lincom `expression'
                        post `contrasts' ("`family'") (`g') (`ref') ("`metric'") ///
                            (r(estimate)) (r(se)) (r(lb)) (r(ub)) (r(p))
                    }
                }
            }
            * Saturated year interactions: no assumed linear trend in this diagnostic.
            quietly areg y i.sg ib`ref'.group##ib2019.year [aw=base_weight], ///
                absorb(sy) vce(cluster stateicp)
            foreach g of local groups {
                if `g' != `ref' {
                    quietly test `g'.group#2016.year `g'.group#2017.year `g'.group#2018.year
                    post `pretests' ("`family'") (`g') (`ref') (r(p))
                    foreach yr in 2016 2017 2018 2019 2021 2022 2023 2024 {
                        if `yr' == 2019 {
                            post `events' ("`family'") (`g') (`ref') (`yr') (0) (0) (0) (0)
                        }
                        else {
                            quietly lincom `g'.group#`yr'.year
                            post `events' ("`family'") (`g') (`ref') (`yr') ///
                                (r(estimate)) (r(se)) (r(lb)) (r(ub))
                        }
                    }
                }
            }
        }
    }
}
foreach handle in results paths support contrasts events pretests {
    postclose ``handle''
}
foreach file in trend_results trend_paths common_support relative_changes event_gaps pretrend_tests {
    use "data/processed/`file'.dta", clear
    export delimited using "outputs/tables/`file'.csv", replace
}
file open done using "outputs/tables/ANALYSIS_COMPLETE.txt", write replace
file write done "Trend analysis completed successfully." _n
file close done
log close
