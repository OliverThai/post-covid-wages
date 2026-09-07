# Post COVID Wages

This project looks at how wages changed after COVID using public ACS/IPUMS data. I adjust earnings for inflation to see whether workers could actually afford more, then compare changes across groups of workers, industries, states, and occupations suited to remote work.

I use Stata to clean the data and run regressions, and R to make the figures.

## Research Question

How did wages change after COVID after accounting for inflation, and which groups had stronger growth?

The project also compares occupations that are more and less suited to remote work. This helps show whether jobs that could be done from home had stronger wage growth after COVID.

## Data

The worker data comes from the American Community Survey (ACS), accessed through IPUMS. The sample includes 2016, 2017, 2018, 2019, 2021, 2022, 2023, and 2024. Save the raw ACS file here:

```text
data/raw/usa_00001.dta
```

The project uses these ACS/IPUMS variables:

```text
YEAR
AGE
SEX
RACE
EDUC
EMPSTAT
OCC
OCCSOC
IND
STATEICP
INCWAGE
PERWT
```

The Dingel and Neiman work from home file measures how suited each occupation is to remote work. Save it here:

```text
data/raw/remote/occupations_workathome.csv
```

That file should include:

```text
onetsoccode
title
teleworkable
```

The ACS extract includes `OCCSOC`, so the Stata code can merge workers to the remote work data using SOC occupation codes.

## Main Variables

The main outcome is annual wage income in 2024 dollars. Using the same year's dollars allows wages to be compared after accounting for inflation:

```stata
gen annual_wage = incwage
gen real_annual_wage = annual_wage * (313.689 / cpi)
gen log_real_wage = log(real_annual_wage)
```

I use annual wage income because the weeks worked variable, `WKSWORK1`, is missing for 2016 through 2018 in the current extract. Without it, hourly wages cannot be calculated consistently across years. I adjust each year's income using the annual Consumer Price Index for All Urban Consumers (CPI-U).

The after COVID variable is:

```stata
gen covid = year > 2020
```

The sample keeps employed workers ages 25 to 54.

## Method

The basic regression compares real wages before and after COVID:

```text
log_real_wage = covid + controls
```

The remote work regression uses an interaction:

```text
log_real_wage = remote_workable + covid + remote_workable x covid + controls
```

The main coefficient is:

```text
1.remote_workable#1.covid
```

If this coefficient is positive, occupations suited to remote work had higher wage growth after COVID relative to occupations less suited to remote work. If it is negative, they had lower relative wage growth.

Because the outcome is the log of real annual wage income, a coefficient of `0.05` represents roughly a 5 percent difference in earnings after accounting for inflation.

## How to Run

Open Stata and move into the project folder:

```stata
cd "PATH/TO/post-covid-wages"
```

Replace `PATH/TO` with the place where the project is saved on your computer.

Then run:

```stata
do code/00_setup.do
do code/01_build_data.do
do code/02_analysis.do
```

The last Stata file runs the R figure script automatically. If R does not run from Stata, run this separately in Terminal:

```text
Rscript code/03_figures.R
```

## Outputs

Main cleaned data files:

```text
data/processed/cleaned.dta
data/processed/remote_soc_only.dta
data/processed/analysis_data.dta
```

Tables:

```text
outputs/tables/summary_stats.txt
outputs/tables/regressions.txt
outputs/tables/top_industry_growth.csv
outputs/tables/top_state_wage_levels.csv
outputs/tables/percent_growth_by_group.csv
```

Figures:

```text
outputs/figures/overall_wage_growth.png
outputs/figures/log_wage_trends.png
outputs/figures/top_industry_growth.png
outputs/figures/state_wage_levels.png
outputs/figures/p10_p50_p90_trends.png
outputs/figures/percent_growth_by_group.png
```

## Results

The full results and discussion are in [research_summary.md](research_summary.md).

Average annual wage income increased by about 22 percent after COVID. After accounting for inflation, the increase was only about 2.4 percent. This shows that higher prices took away most of the increase in purchasing power.

Younger workers, women, and workers without college degrees had stronger average real earnings growth than their comparison groups. Workers in occupations suited to remote work earned more overall, but had slightly weaker growth. These differences may reflect changes in pay, working hours, and who remained employed. Since the data does not follow the same workers each year, the results do not show that every worker in these groups became better off.

The full regression output is saved in `outputs/tables/regressions.txt`.
