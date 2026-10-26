# Reproducible results

Generated from Stata tables. Main scenario fixes 2019 single-year age, sex, degree and state composition.
Inference is conditional on a linear model and state clustering, not a causal COVID design.

| Group | Pre annual growth (%) | Post annual growth (%) | Slope change (log pp/year) | 2024 departure (%) |
|---|---:|---:|---:|---:|
| All employed earners | 1.04 | 0.79 | -0.25 | -4.83 |
| Ages 25-34 | 1.57 | 1.46 | -0.11 | -4.78 |
| Ages 35-44 | 0.86 | 0.51 | -0.35 | -4.89 |
| Ages 45-54 | 0.62 | 0.31 | -0.31 | -4.81 |
| Men | 0.98 | 0.56 | -0.41 | -5.83 |
| Women | 1.11 | 1.05 | -0.06 | -3.71 |
| Below bachelor's | 1.30 | 0.98 | -0.32 | -6.00 |
| Bachelor's or higher | 0.66 | 0.51 | -0.15 | -3.10 |
| 25-34: below bachelor's | 1.96 | 1.44 | -0.51 | -6.94 |
| 25-34: bachelor's or higher | 1.03 | 1.50 | 0.46 | -1.67 |
| 35-44: below bachelor's | 1.16 | 0.90 | -0.25 | -5.90 |
| 35-44: bachelor's or higher | 0.45 | -0.03 | -0.47 | -3.48 |
| 45-54: below bachelor's | 0.73 | 0.56 | -0.17 | -5.06 |
| 45-54: bachelor's or higher | 0.45 | -0.08 | -0.53 | -4.43 |

## Sensitivity: overall earnings

| Specification | Pre annual growth (%) | Post annual growth (%) | 2024 departure (%) |
|---|---:|---:|---:|
| Fixed 2019 composition | 1.04 | 0.79 | -4.83 |
| Changing composition | 1.41 | 1.03 | -3.53 |
| Cap at pre-period P99 | 1.03 | 0.80 | -4.76 |
| ACS income timing adjustment | 1.14 | 0.14 | -4.83 |
| Include earners not employed now | 1.37 | 1.30 | -5.60 |
| Also fix race composition | 1.13 | 0.85 | -2.81 |
| Post trend starts in 2022 | 1.04 | 1.49 | -4.39 |
| Pre trend starts in 2017 | 1.10 | 0.79 | -5.13 |

## Sample and inference

Employed positive-earner records: 7,057,956
Minimum fixed-cell population coverage (main): 100.000%
Minimum fixed-cell population coverage (race sensitivity): 98.218%

Relative changes use state-year effects to absorb common local shocks. The 18 post-period relative contrasts receive Holm adjustment together. Pretrend tests are adjusted separately across nine comparisons.
The growth-rate change is 100 times the log slope change, not the exact difference between the two exponentiated annual rates.
State-clustered intervals do not account for unrestricted common national shocks or full ACS replicate-weight variance. Baseline composition weights are treated as fixed.
The post trend is measured within 2021-2024 (2022-2024 in omit2021). It does not include the unobserved 2020 transition.
A negative fitted 2024 departure does not prove that COVID caused a loss or that the extrapolated trend would have continued.
