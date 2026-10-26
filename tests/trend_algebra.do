* Synthetic data test: recover known pre/post slopes and group differences.
* Synthetic observations are never used in the research outputs.
version 16
clear all
set more off
set obs 16
gen stateicp = ceil(_n/2)
gen group = mod(_n-1,2)+1
expand 8
bysort stateicp group: gen year = 2015+_n
replace year = year+1 if year>=2020
gen t = year-2019
gen post = year>=2021
gen ramp = (year-2021)*post
gen base_weight = 100+stateicp
gen double y = 10 + stateicp*.03 + group*.2 + ///
    (.01 + (group==2)*.02)*t + (-.03 + (group==2)*.01)*post + ///
    (.005 + (group==2)*.002)*ramp
areg y c.t i.post c.ramp [aw=base_weight] if group==1, absorb(stateicp)
assert abs(_b[t]-.01)<1e-8
assert abs(_b[ramp]-.005)<1e-8
assert abs(_b[1.post]+.03)<1e-8
lincom 1.post + 3*ramp
assert abs(r(estimate)+.015)<1e-8
egen sy = group(stateicp year)
egen sg = group(stateicp group)
areg y i.sg ib1.group##c.t ib1.group##i.post ib1.group##c.ramp ///
    [aw=base_weight], absorb(sy)
assert abs(_b[2.group#c.t]-.02)<1e-8
assert abs(_b[2.group#1.post]-.01)<1e-8
assert abs(_b[2.group#c.ramp]-.002)<1e-8
file open passed using "outputs/tables/SYNTHETIC_TESTS_PASSED.txt", write replace
file write passed "Known trend parameters recovered." _n
file close passed
