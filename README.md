# Post COVID Wages

This project studies how real annual earnings changed after COVID. It compares growth from 2016 to 2019 with growth from 2021 to 2024, looking at age, sex and education. Stata handles the data and regressions; R makes the figures.

The main question is whether earnings grew faster than they had before. For example, workers ages 25 to 34 had estimated annual growth of 1.57% before COVID and 1.46% afterward. They still grew faster than older workers, but that difference was already present before the pandemic.

![Annual earnings growth before and after COVID](outputs/figures/02_growth_rates.png)

The analysis accounts for inflation and keeps the mix of ages, sexes, degree status and states the same as in 2019. It also checks how the results change with different years and sample choices. These comparisons describe earnings patterns; they do not prove that COVID caused them. Read the [research summary](research_summary.md) for the findings and what they mean.

## Data

The project uses public American Community Survey data from [IPUMS USA](https://usa.ipums.org/usa/). Select the individual annual ACS samples for 2016, 2017, 2018, 2019, 2021, 2022, 2023 and 2024. Do not select the combined five year samples. There are no 2020 or 2025 observations in this extract.

Include these variables:

```text
YEAR SAMPLE SERIAL PERNUM AGE SEX RACE EDUC EDUCD EMPSTAT
STATEICP PERWT INCWAGE UHRSWORK WKSWORK1
```

Choose Stata format and follow the IPUMS import instructions. Place the resulting dataset here:

```text
data/raw/usa_00001.dta
```

The scripts expect lowercase variable names after import. Exact weeks worked is not available for every year, so the project uses annual earnings rather than calculating hourly pay. The main sample includes about 7.1 million records of employed people ages 25 to 54 with positive wage income. These are different people each year, not individual workers tracked over time.

The code converts earnings to 2024 dollars using the Consumer Price Index. Do not apply another inflation adjustment to the extract beforehand. Income covers the previous 12 months, so the adjustment is approximate. Details are available in the [income definition](https://usa.ipums.org/usa-action/variables/INCWAGE), [income timing guidance](https://usa.ipums.org/usa/acsincadj.shtml), and [price index table](https://www.bls.gov/regions/mid-atlantic/data/consumerpriceindexannualandsemiannual_table.htm).

## Running the project

Use Stata 16 or newer and R. Install the R packages once:

```r
install.packages(c("ggplot2", "haven", "data.table"))
```

Only `ggplot2` is needed for the figures. The other two packages are used for the optional data checks.

In Stata, replace the placeholder below with the location of your project folder:

```stata
cd "PATH/TO/post-covid-wages"
do run_project.do
```

This runs the analysis and calls R to make the figures without opening RStudio. If Stata cannot find Rscript, give it the location of that program:

```stata
do run_project.do "/PATH/TO/Rscript"
```

You can also run the steps separately in Stata:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

Then run this from a terminal in the project folder:

```text
Rscript code/03_figures.R
```

The scripts are written for the eight listed years. Adding years requires updating the inflation values, comparisons and checks, not just replacing the raw file.

## Results and checks

The six figures are saved in `outputs/figures`, and the tables are saved in `outputs/tables`. The [results report](outputs/tables/research_results.md) updates automatically when the R script runs. The research summary is a separate written interpretation and needs to be reviewed when results change. Raw and processed survey data stay local; only combined results are published.

The [method details](research_design.md) explain the regressions, weights and limits of the analysis. They are separate from the summary so the main findings can be read without working through every statistical detail.

To check the calculations after running the project, run `do tests/trend_algebra.do` in Stata and `Rscript tests/validate_outputs.R` from the terminal. These check known regression results using test data and verify that the reported numbers agree with the processed data. Passing them does not establish cause and effect.

The earlier remote work comparison and industry and state rankings are no longer part of the analysis. Previous local outputs are stored in `outputs/legacy/pre_revision` and should not be used as current results.
