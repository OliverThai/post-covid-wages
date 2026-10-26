# Post COVID Wages

Did real annual earnings grow unusually quickly after COVID, or were differences between groups already present beforehand?

This project compares **annual growth in 2016-2019 with annual growth in 2021-2024**, rather than just comparing two period averages. It also measures how far fitted 2024 earnings were above or below a continuation of the earlier trend. Stata handles cleaning and estimation; R makes the figures.

The distinction changes the findings. Workers ages 25-34 had faster growth than older workers, but their annual growth was already about 1.57% before COVID and was about 1.46% afterward. Faster growth than another group is not the same as an acceleration after COVID.

![Annual growth before and after COVID](outputs/figures/02_growth_rates.png)

## Data and sample

Public ACS one-year microdata from [IPUMS USA](https://usa.ipums.org/usa/) cover 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. There are no 2020 or 2025 observations in this extract. Do not substitute overlapping five-year ACS samples.

The main sample contains 7,057,956 records of employed people ages 25-54 with positive wage and salary income. It no longer requires an occupation match and does not delete high earners using the old two-standard-deviation rule. A separate specification includes positive earners who were not employed at the survey date.

Create an IPUMS USA extract with these one-year samples and variables:
`YEAR SAMPLE SERIAL PERNUM AGE SEX RACE EDUC EDUCD EMPSTAT STATEICP PERWT INCWAGE UHRSWORK WKSWORK1`.
Choose Stata format, use the supplied import instructions if needed, and put the resulting dataset at:

```text
data/raw/usa_00001.dta
```

The expected imported names are lowercase. Exact weeks worked is not available for all years; it is not used to construct the main outcome. Do not apply an IPUMS monetary adjustment on top of this script's inflation conversion.

Annual earnings are converted to 2024 dollars using national CPI-U. ACS income refers to the preceding 12 months, so the conversion is an approximation to the timing of income received. [Income definition](https://usa.ipums.org/usa-action/variables/INCWAGE), [income timing guidance](https://usa.ipums.org/usa/acsincadj.shtml), [CPI source](https://www.bls.gov/regions/mid-atlantic/data/consumerpriceindexannualandsemiannual_table.htm).

## Method

The main analysis holds the joint distribution of single-year age, sex, degree status and state at its 2019 composition. It compares annual mean log earnings using state-level panels. This avoids interpreting a growing share of older or college-educated respondents as pay growth. It does not hold every worker characteristic constant or follow individuals.

The model estimates an earlier trend, a level difference in 2021, and a change in slope after 2021. The model and exact weighting formula are in [research_design.md](research_design.md). Separate comparisons include state-year effects, allowing groups to be compared after accounting for shocks shared within a state and year.

The analysis includes earlier-trend diagnostics, a 2019 forecast backtest, eight specifications, state-clustered intervals, and adjustments for multiple group comparisons. **These are descriptive trend comparisons, not identified causal effects of COVID.** Only four pre-period years are available, and post-period slopes are sensitive to the starting year.

The previous remote-work comparison and industry/state rankings are retired from the active workflow. Their classification and interpretation problems should not be carried into the revised results. Old local outputs are preserved under `outputs/legacy/pre_revision/`; they are not current findings.

## Run

Requires Stata 16 or newer and R with `ggplot2`. For the optional independent validation checks, install `haven` and `data.table` too:

```r
install.packages(c("ggplot2", "haven", "data.table"))
```

From Stata:

```stata
cd "PATH/TO/post-covid-wages"
do run_project.do
```

This runs all Stata steps and calls R. If Rscript is not on Stata's PATH, pass its executable path:

```stata
do run_project.do "/PATH/TO/Rscript"
```

Or run the steps separately:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

Then, from a terminal in the project folder:

```text
Rscript code/03_figures.R
```

The code intentionally rejects unrecognized years or sample types rather than silently treating them as comparable. Extending the analysis requires adding CPI values, updating the model windows and tests, and reviewing sample definitions.

## Results and checks

Read [research_summary.md](research_summary.md) for interpretation and [the generated numerical report](outputs/tables/research_results.md) for the complete tables. The report is rebuilt by the R script; the root summary is a reviewed snapshot of that output.

The six current figures show earnings versus the earlier trend, pre/post growth rates, departures from trend, yearly group gaps, sensitivity checks, and age-by-degree patterns. Aggregated results are public; raw and processed microdata stay local.

Run these checks after the pipeline:

```stata
do tests/trend_algebra.do
```

```text
Rscript tests/validate_outputs.R
```

The first checks known coefficients on synthetic test data, which never enters the research sample. The second independently checks aggregation, identities between estimates, sample coverage, and output completeness. The run manifest records input/code checksums and the R environment. Stata logs record the software version and estimation steps.

A successful test run validates implementation checks, not the assumptions needed for causal inference.
